import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/providers.dart';
import '../../../data/datasources/local/auth_local_datasource.dart';
import '../../../data/datasources/remote/auth_remote_datasource.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio);
});

final authLocalDataSourceProvider =
    Provider<AuthLocalDataSource>((ref) => AuthLocalDataSourceImpl());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  final local = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(remote, local);
});

/// Holds current auth state: logged out, loading, logged in (with user),
/// or error. This drives both the login screen and the app-level gate.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final Failure failure;
  const AuthError(this.failure);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(const AuthInitial()) {
    _checkExistingSession();
  }

  void _checkExistingSession() {
    if (repository.isLoggedIn()) {
      final cachedUser = repository.getCachedUser();
      if (cachedUser != null) {
        state = AuthAuthenticated(cachedUser);
        return;
      }
    }
    state = const AuthUnauthenticated();
  }

  Future<void> login({required String username, required String password}) async {
    state = const AuthLoading();
    final result = await repository.login(username: username, password: password);
    if (result.isSuccess) {
      state = AuthAuthenticated(result.data!);
    } else {
      state = AuthError(result.failure!);
    }
  }

  Future<void> logout() async {
    await repository.logout();
    state = const AuthUnauthenticated();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});