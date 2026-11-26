import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

Exception mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return NetworkException('Tidak bisa terhubung ke server. Periksa koneksimu.');
    default:
      break;
  }

  final res = e.response;
  final data = res?.data;
  var message = 'Terjadi kesalahan. Coba lagi.';
  Map<String, List<String>>? fieldErrors;

  if (data is Map<String, dynamic>) {
    message = (data['message'] as String?) ?? message;
    final errors = data['errors'];
    if (errors is Map) {
      fieldErrors = errors.map(
        (k, v) => MapEntry(k.toString(), List<String>.from(v as List)),
      );
    }
  }

  return ServerException(message, statusCode: res?.statusCode, fieldErrors: fieldErrors);
}