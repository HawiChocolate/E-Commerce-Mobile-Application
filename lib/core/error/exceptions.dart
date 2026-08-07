/// Exceptions thrown by datasources (network/API layer).
/// These get caught and translated into Failures by repositories.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Something went wrong on the server.']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'No local data found.']);
}