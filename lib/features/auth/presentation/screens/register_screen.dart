import 'package:budgetin_mobile/features/auth/presentation/screens/terms_dialog.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _c = Get.find<AuthController>();
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _agree = false;

  bool _nameErr = false;
  bool _emailErr = false;
  bool _passErr = false;

  @override
  void initState() {
    super.initState();
    // Merah hilang otomatis begitu field mulai diisi
    _nameC.addListener(() {
      if (_nameErr && _nameC.text.trim().isNotEmpty) {
        setState(() => _nameErr = false);
      }
    });
    _emailC.addListener(() {
      if (_emailErr && _emailC.text.trim().isNotEmpty) {
        setState(() => _emailErr = false);
      }
    });
    _passC.addListener(() {
      if (_passErr && _passC.text.isNotEmpty) {
        setState(() => _passErr = false);
      }
    });
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  void _onRegister() {
  setState(() {
    _nameErr = _nameC.text.trim().isEmpty;
    _emailErr = _emailC.text.trim().isEmpty;
    _passErr = _passC.text.isEmpty;
  });

  if (_nameErr || _emailErr || _passErr) {
    _c.errorMessage.value = 'Lengkapi semua data terlebih dahulu.';
    return;
  }

  if (!_agree) {
    _c.errorMessage.value = 'Setujui Syarat & Ketentuan terlebih dahulu.';
    return;
  }

  _c.errorMessage.value = null;
  _c.register(
    name: _nameC.text.trim(),
    email: _emailC.text.trim(),
    password: _passC.text,
  );
}

  Future<void> _openTerms() async {
    final accepted = await TermsDialog.show(context);
    if (accepted == true && mounted) {
      setState(() => _agree = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Sudah punya akun? ',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          AuthLink(
            label: 'Masuk',
            onPressed: () => Get.offNamed(AppRoutes.login),
          ),
        ],
      ),
      child: Obx(() {
        final error = _c.errorMessage.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              title: 'Buat akun baru',
              subtitle: 'Gratis, cuma butuh beberapa detik.',
            ),
            const VGap(20),
            if (error != null) ...[
              AuthErrorBanner(message: error),
              const VGap(14),
            ],
            AuthTextField(
              label: 'Nama',
              controller: _nameC,
              errorText: _c.fieldErrors['name'],
            ),
            const VGap(14),
            AuthTextField(
              label: 'Email',
              controller: _emailC,
              errorText: _c.fieldErrors['email'],
              keyboardType: TextInputType.emailAddress,
            ),
            const VGap(14),
            AuthTextField(
              label: 'Password',
              controller: _passC,
              isPassword: true,
              errorText: _c.fieldErrors['password'],
            ),
            const VGap(14),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AuthCheckbox(
                  value: _agree,
                  onChanged: (v) => setState(() => _agree = v),
                  child: const Text(
                    'Aku setuju dengan ',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: _openTerms,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    'Syarat & Ketentuan',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const VGap(20),
            PrimaryButton(
              label: 'Buat akun',
              isLoading: _c.isLoading.value,
              onPressed: _onRegister,
            ),
            const VGap(16),
            const OrDivider(),
            const VGap(16),
            GoogleButton(label: 'Daftar dengan Google', onPressed: () {}),
          ],
        );
      }),
    );
  }
}
