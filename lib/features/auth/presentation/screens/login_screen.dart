import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/google_button.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/v_gap.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_checkbox.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_link.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/or_divider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _c = Get.find<AuthController>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _remember = false;

  void _onLogin() => _c.login(
    email: _emailC.text.trim(),
    password: _passC.text,
    remember: _remember,
  );

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Belum punya akun? ',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          AuthLink(
            label: 'Daftar',
            onPressed: () => Get.offNamed(AppRoutes.register),
          ),
        ],
      ),
      child: Obx(() {
        final error = _c.errorMessage.value;
        final hasError = error != null;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              title: 'Masuk ke Budgetin',
              subtitle: 'Selamat datang lagi! Yuk cek dompetmu.',
            ),
            const VGap(20),
            if (hasError) ...[AuthErrorBanner(message: error), const VGap(14)],
            AuthTextField(
              label: 'Email',
              controller: _emailC,
              hasError: hasError,
              keyboardType: TextInputType.emailAddress,
            ),
            const VGap(14),
            AuthTextField(
              label: 'Password',
              controller: _passC,
              isPassword: true,
              hasError: hasError,
            ),
            const VGap(14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AuthCheckbox(
                    value: _remember,
                    onChanged: (v) => setState(() => _remember = v),
                    child: const Text(
                      'Ingat password',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    'Lupa password?',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const VGap(20),
            PrimaryButton(
              label: 'Masuk',
              isLoading: _c.isLoading.value,
              onPressed: _onLogin,
            ),
            const VGap(16),
            const OrDivider(),
            const VGap(16),
            GoogleButton(label: 'Lanjut dengan Google', onPressed: () {}),
          ],
        );
      }),
    );
  }
}