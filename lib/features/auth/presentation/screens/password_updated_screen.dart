import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/v_gap.dart';
import '../widgets/auth_icon_badge.dart';
import '../widgets/auth_layout.dart';

class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthIconBadge(
            icon: Icons.check,
            size: 72,
            iconSize: 40,
            background: AppColors.success,
            foreground: Colors.white,
          ),
          const VGap(20),
          const Text(
            'Password diperbarui',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const VGap(8),
          const Text(
            'Password barumu sudah aktif. Silakan masuk dengan password baru.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const VGap(24),
          PrimaryButton(
            label: 'Masuk',
            onPressed: () => Get.offAllNamed(AppRoutes.login),
          ),
        ],
      ),
    );
  }
}