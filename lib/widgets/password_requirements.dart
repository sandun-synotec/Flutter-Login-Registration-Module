import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/validators.dart';

class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final bool hasMinLength = Validators.hasMinLength(password);
    final bool hasUppercase = Validators.hasUppercase(password);
    final bool hasLowercase = Validators.hasLowercase(password);
    final bool hasNumber = Validators.hasNumber(password);
    final bool hasSpecial = Validators.hasSpecial(password);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.passwordRequirementHeader,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          _buildItem(AppStrings.ruleMinLength, hasMinLength),
          const SizedBox(height: 4),
          _buildItem(AppStrings.ruleUppercase, hasUppercase),
          const SizedBox(height: 4),
          _buildItem(AppStrings.ruleLowercase, hasLowercase),
          const SizedBox(height: 4),
          _buildItem(AppStrings.ruleNumber, hasNumber),
          const SizedBox(height: 4),
          _buildItem(AppStrings.ruleSpecial, hasSpecial),
        ],
      ),
    );
  }

  Widget _buildItem(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 15,
          color: isMet ? AppColors.success : AppColors.textMuted,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
              color: isMet ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
