class ServerException implements Exception {
  ServerException(this.message, {this.statusCode, this.fieldErrors});

  final String message;
  final int? statusCode;
  final Map<String, List<String>>? fieldErrors;
}

class NetworkException implements Exception {
  NetworkException(this.message);

  final String message;
}