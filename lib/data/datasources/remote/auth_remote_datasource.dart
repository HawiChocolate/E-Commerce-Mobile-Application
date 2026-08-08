import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/error_handler.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Returns the auth token on success.
  Future<String> login({required String username, required String password});

  /// Fetches all users so we can match the logged-in user by username
  /// (the Fake Store API login endpoint doesn't return user details).
  Future<List<UserModel>> getAllUsers();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
      );
      final token = response.data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw ErrorHandler.handle(
          DioException(
            requestOptions: response.requestOptions,
            error: 'No token returned',
          ),
        );
      }
      return token;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await dio.get(ApiConstants.users);
      final data = response.data as List;
      return data
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}