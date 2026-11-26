import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../shared/widgets/v_gap.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_icon_badge.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_link.dart';

class ResetLinkSentScreen extends StatefulWidget {
  const ResetLinkSentScreen({super.key});

  @override
  State<ResetLinkSentScreen> createState() => _ResetLinkSentScreenState();
}

class _ResetLinkSentScreenState extends State<ResetLinkSentScreen> {
  static const int _resendSeconds = 60;

  late final String _email;
  Timer? _timer;
  int _remaining = _resendSeconds;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    _email = args is String ? args : '';
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_remaining > 0) _remaining--;
        if (_remaining == 0) t.cancel();
      });
    });
  }

  String get _formattedTime {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onResend() {
    if (_remaining > 0) return;
    // TODO: panggil endpoint kirim ulang tautan reset
    setState(() => _remaining = _resendSeconds);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      footer: Center(
        child: AuthLink(
          label: 'Kembali ke login',
          fontSize: 13,
          onPressed: () => Get.offAllNamed(AppRoutes.login),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthIconBadge(icon: Icons.mail_outline),
          const VGap(16),
          const Text(
            'Cek email kamu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const VGap(8),
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              children: [
                const TextSpan(
                  text: 'Jika email terdaftar, tautan reset sudah kami kirim ke ',
                ),
                TextSpan(
                  text: _email.isEmpty ? 'emailmu' : _email,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const TextSpan(text: '. Tautan berlaku 30 menit.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const VGap(24),
          SecondaryButton(
            label: _remaining > 0 ? 'Kirim ulang ($_formattedTime)' : 'Kirim ulang',
            onPressed: _remaining == 0 ? _onResend : null,
          ),
        ],
      ),
    );
  }
}