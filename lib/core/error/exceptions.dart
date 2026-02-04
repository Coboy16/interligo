class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Error del servidor', this.statusCode});

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Error de caché'});

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;

  AuthException({this.message = 'No autorizado'});

  @override
  String toString() => 'AuthException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Sin conexión a internet'});

  @override
  String toString() => 'NetworkException: $message';
}
