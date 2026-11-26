import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/v_gap.dart';
import '../widgets/auth_layout.dart';
import '../widgets/otp_input.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 60;

  final _otpC = TextEditingController();
  late final String _email;
  Timer? _timer;
  int _remaining = _resendSeconds;
  String? _error;

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
    _otpC.dispose();
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

  void _onVerify() {
    if (_otpC.text.length < _otpLength) {
      setState(() => _error = 'Masukkan $_otpLength digit kode terlebih dahulu.');
      return;
    }
    setState(() => _error = null);
    // TODO: panggil controller untuk verifikasi (endpoint belum disambungkan)
  }

  void _onResend() {
    if (_remaining > 0) return;
    // TODO: panggil endpoint kirim ulang kode
    _otpC.clear();
    setState(() {
      _error = null;
      _remaining = _resendSeconds;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Periksa folder Spam atau Promosi kalau belum masuk.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const VGap(4),
          TextButton(
            onPressed: () => Get.offNamed(AppRoutes.register),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppColors.primary,
            ),
            child: const Text(
              'Ganti email',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.mark_email_unread_outlined,
                size: 26,
                color: AppColors.primary,
              ),
            ),
          ),
          const VGap(16),
          const Text(
            'Cek email kamu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const VGap(8),
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
              children: [
                const TextSpan(text: 'Kami udah kirim kode 6 digit ke '),
                TextSpan(
                  text: _email.isEmpty ? 'emailmu' : _email,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const TextSpan(text: '. Masukin di bawah buat lanjut.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const VGap(24),
          OtpInput(
            controller: _otpC,
            length: _otpLength,
            hasError: _error != null,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          if (_error != null) ...[
            const VGap(8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppColors.error),
            ),
          ],
          const VGap(20),
          PrimaryButton(label: 'Verifikasi', onPressed: _onVerify),
          const VGap(16),
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              children: [
                const TextSpan(text: 'Belum dapet kode? '),
                if (_remaining > 0) ...[
                  const TextSpan(text: 'Kirim ulang dalam '),
                  TextSpan(
                    text: _formattedTime,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const VGap(8),
          Center(
            child: TextButton(
              onPressed: _remaining == 0 ? _onResend : null,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.primary,
                disabledForegroundColor: AppColors.textSecondary,
              ),
              child: const Text(
                'Kirim ulang',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
