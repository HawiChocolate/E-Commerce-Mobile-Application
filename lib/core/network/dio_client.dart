import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

/// Wraps a single configured Dio instance used throughout the app.
/// Keeping this centralized means base URL, timeouts, and interceptors
/// only need to be set up once.
class DioClient {
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout:
            const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout:
            const Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late final Dio _dio;

  Dio get dio => _dio;
}