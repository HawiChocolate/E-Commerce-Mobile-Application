import 'package:dio/dio.dart';
import 'exceptions.dart';

/// Converts low-level Dio/network errors into our own Exception types.
/// Called from datasources inside try/catch blocks.
class ErrorHandler {
  ErrorHandler._();

  static Exception handle(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return const NetworkException();
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          return ServerException(
              'Server error${statusCode != null ? ' ($statusCode)' : ''}.');
        default:
          return const ServerException();
      }
    }
    return const ServerException();
  }
}