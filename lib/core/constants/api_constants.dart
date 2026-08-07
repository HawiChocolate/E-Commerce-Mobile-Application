/// Centralized API endpoint definitions for Fake Store API.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://fakestoreapi.com';

  // Products
  static const String products = '/products';
  static const String categories = '/products/categories';
  static String productsByCategory(String category) =>
      '/products/category/$category';
  static String productById(int id) => '/products/$id';

  // Users
  static const String users = '/users';
  static String userById(int id) => '/users/$id';

  // Auth
  static const String login = '/auth/login';

  // Timeouts (ms)
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}