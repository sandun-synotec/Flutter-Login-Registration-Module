import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.lock_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primarySubtle,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Icon(icon, size: 28, color: AppColors.primary),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
