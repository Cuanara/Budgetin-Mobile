import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthIconBadge extends StatelessWidget {
  const AuthIconBadge({
    super.key,
    required this.icon,
    this.size = 84,
    this.iconSize = 32,
    this.background = AppColors.primarySoft,
    this.foreground = AppColors.primary,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, size: iconSize, color: foreground),
      ),
    );
  }
}