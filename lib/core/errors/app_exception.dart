sealed class AppException implements Exception {

  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// The request never got a proper answer: no internet, timeout, unreachable.
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// The server answered, but with an error or an unexpected response.
class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

/// The content was downloaded, but saving it on this device failed.
class StorageException extends AppException {
  const StorageException(super.message);
}