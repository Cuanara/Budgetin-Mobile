import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/v_gap.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();
  String? _passError;
  String? _confirmError;

  @override
  void dispose() {
    _passC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  void _onSave() {
    final pass = _passC.text;
    final confirm = _confirmC.text;

    String? passError;
    if (pass.length < 8) {
      passError = 'Minimal 8 karakter.';
    } else if (!RegExp(r'[A-Za-z]').hasMatch(pass) ||
        !RegExp(r'\d').hasMatch(pass)) {
      passError = 'Gunakan kombinasi huruf dan angka.';
    }
    final confirmError = confirm != pass ? 'Password tidak sama.' : null;

    setState(() {
      _passError = passError;
      _confirmError = confirmError;
    });
    if (passError != null || confirmError != null) return;

    // TODO: panggil endpoint reset password (token dari tautan email)
    Get.offAllNamed(AppRoutes.passwordUpdated);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      topAligned: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthHeader(
            centered: false,
            title: 'Buat password baru',
            subtitle: 'Gunakan minimal 8 karakter dengan kombinasi huruf dan angka.',
          ),
          const VGap(20),
          AuthTextField(
            label: 'Password baru',
            controller: _passC,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            errorText: _passError,
          ),
          const VGap(14),
          AuthTextField(
            label: 'Ulangi password',
            controller: _confirmC,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            hintText: 'Ketik ulang password',
            errorText: _confirmError,
          ),
          const VGap(20),
          PrimaryButton(label: 'Simpan password', onPressed: _onSave),
        ],
      ),
    );
  }
}