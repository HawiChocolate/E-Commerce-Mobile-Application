import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user_model.dart';
import 'product_repository.dart'; // for the shared Result<T> wrapper

abstract class AuthRepository {
  Future<Result<UserModel>> login({
    required String username,
    required String password,
  });
  bool isLoggedIn();
  UserModel? getCachedUser();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Result<UserModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final token =
          await remoteDataSource.login(username: username, password: password);

      // Fake Store API's login doesn't return the user profile, so we
      // fetch all users and match by username to build a usable session.
      final users = await remoteDataSource.getAllUsers();
      final matchedUser = users.firstWhere(
        (u) => u.username == username,
        orElse: () => users.first, // graceful fallback if username not found
      );

      await localDataSource.saveSession(token: token, user: matchedUser);
      return Result.success(matchedUser);
    } on NetworkException catch (e) {
      return Result.failureResult(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failureResult(ServerFailure(e.message));
    } catch (e) {
      return Result.failureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  bool isLoggedIn() => localDataSource.isLoggedIn();

  @override
  UserModel? getCachedUser() => localDataSource.getCachedUser();

  @override
  Future<void> logout() => localDataSource.clearSession();
}