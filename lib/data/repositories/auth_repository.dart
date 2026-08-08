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

  AuthRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<Result<UserModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      // Login and get authentication token
      final token = await remoteDataSource.login(
        username: username,
        password: password,
      );

      // Fake Store API's login doesn't return the user profile,
      // so we fetch all users and match by username.
      final users = await remoteDataSource.getAllUsers();

      // Handle the case where the API returns no users.
      final matchedUser = users.isEmpty
          ? throw const ServerException(
              'No user records found.',
            )
          : users.firstWhere(
              (u) => u.username == username,
              orElse: () => users.first,
            );

      // Save the user's session locally.
      await localDataSource.saveSession(
        token: token,
        user: matchedUser,
      );

      return Result.success(matchedUser);
    }

    // Network error
    on NetworkException catch (e) {
      return Result.failureResult(
        NetworkFailure(e.message),
      );
    }

    // Server/API error
    on ServerException catch (e) {
      return Result.failureResult(
        ServerFailure(e.message),
      );
    }

    // Any unexpected error
    catch (e) {
      return Result.failureResult(
        UnknownFailure(e.toString()),
      );
    }
  }

  @override
  bool isLoggedIn() {
    return localDataSource.isLoggedIn();
  }

  @override
  UserModel? getCachedUser() {
    return localDataSource.getCachedUser();
  }

  @override
  Future<void> logout() {
    return localDataSource.clearSession();
  }
}