import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/v_gap.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_link.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailC = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _emailC.dispose();
    super.dispose();
  }

  bool _isValidEmail(String v) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);

  void _onSubmit() {
    final email = _emailC.text.trim();
    if (!_isValidEmail(email)) {
      setState(() => _error = 'Masukkan email yang valid.');
      return;
    }
    setState(() => _error = null);
    // TODO: panggil endpoint lupa password (kirim tautan reset)
    Get.toNamed(AppRoutes.forgotPasswordSent, arguments: email);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      topAligned: true,
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Ingat password? ',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          AuthLink(
            label: 'Masuk',
            onPressed: () => Get.offAllNamed(AppRoutes.login),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(
            centered: false,
            title: 'Lupa password?',
            subtitle:
                'Masukkan email akunmu. Kami akan mengirim tautan untuk membuat password baru.',
          ),
          const VGap(20),
          AuthTextField(
            label: 'Email',
            controller: _emailC,
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            errorText: _error,
          ),
          const VGap(20),
          PrimaryButton(label: 'Kirim tautan reset', onPressed: _onSubmit),
        ],
      ),
    );
  }
}