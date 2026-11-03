import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/feedback_snackbar.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String? initialIdentifier;

  const ForgotPasswordDialog({super.key, this.initialIdentifier});

  static Future<void> show(BuildContext context, {String? initialIdentifier}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          ForgotPasswordDialog(initialIdentifier: initialIdentifier),
    );
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identifierController;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController(
      text: widget.initialIdentifier ?? '',
    );
  }

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.forgotPassword(
      _identifierController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      FeedbackSnackbar.showSuccess(
        context,
        authProvider.successMessage ?? 'Reset instructions sent successfully.',
      );
    } else {
      FeedbackSnackbar.showError(
        context,
        authProvider.errorMessage ?? 'Failed to send reset link.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.primarySubtle,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        AppStrings.forgotPasswordTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  AppStrings.forgotPasswordSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _identifierController,
                  label: AppStrings.emailOrMobileLabel,
                  hint: AppStrings.emailOrMobileHint,
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    size: 20,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: Validators.validateIdentifier,
                  onFieldSubmitted: (_) => _handleSubmit(),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: AppStrings.sendResetLink,
                  isLoading: authProvider.isLoading,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
