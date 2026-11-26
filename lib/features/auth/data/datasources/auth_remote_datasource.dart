import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/api_endpoint.dart';
import '../../../../core/network/dio_error_mapper.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<void> register(String name, String email, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final res = await dio.post(
        ApiEndpoint.login,
        data: {'email': email, 'password': password},
      );
      debugPrint('LOGIN ${res.statusCode}: ${res.data}');
      return _parse(res.data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      await dio.post(
        ApiEndpoint.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation':
              password, // hapus kalau backend tidak meminta
        },
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post(ApiEndpoint.logout);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  AuthResponseModel _parse(dynamic body) {
    final map = body as Map<String, dynamic>;
    final data = map['data'] as Map<String, dynamic>;
    return AuthResponseModel.fromJson(data);
  }
}
