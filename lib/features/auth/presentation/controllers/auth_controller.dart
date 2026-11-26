import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthController extends GetxController {
  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  });

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  final isLoading = false.obs;
  final errorMessage = RxnString();
  final fieldErrors = <String, String>{}.obs;

  void _reset() {
    errorMessage.value = null;
    fieldErrors.clear();
  }

  Future<void> login({
    required String email,
    required String password,
    required bool remember,
  }) async {
    _reset();
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email dan password wajib diisi.';
      return;
    }

    isLoading.value = true;
    final result = await loginUseCase(
      LoginParams(email: email, password: password, remember: remember),
    );
    isLoading.value = false;

    result.fold((failure) {
      if (failure is ServerFailure &&
          (failure.statusCode == 401 || failure.statusCode == 422)) {
        errorMessage.value = 'Email atau password salah. Coba lagi';
      } else {
        errorMessage.value = failure.message;
      }
    }, (_) => Get.offAllNamed(AppRoutes.home));
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _reset();
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Semua kolom wajib diisi.';
      return;
    }

    isLoading.value = true;
    final result = await registerUseCase(
      RegisterParams(name: name, email: email, password: password),
    );
    isLoading.value = false;

       result.fold(
      (failure) {
        if (failure is ServerFailure && failure.statusCode == 422) {
          errorMessage.value = 'Ada yang belum sesuai. Periksa lagi.';
          failure.fieldErrors?.forEach((field, messages) {
            if (messages.isNotEmpty) fieldErrors[field] = messages.first;
          });
        } else {
          errorMessage.value = failure.message;
        }
      },
      (_) => Get.offNamed(AppRoutes.verifyEmail, arguments: email),
    );
  }

  Future<void> logout() async {
    await logoutUseCase(const NoParams());
    Get.offAllNamed(AppRoutes.login);
  }
}
