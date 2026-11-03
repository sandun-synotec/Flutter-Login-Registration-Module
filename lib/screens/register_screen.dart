import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/feedback_snackbar.dart';
import '../widgets/password_requirements.dart';
import '../widgets/responsive_auth_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  String _currentPasswordText = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      if (_currentPasswordText != _passwordController.text) {
        setState(() {
          _currentPasswordText = _passwordController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      FeedbackSnackbar.showSuccess(
        context,
        authProvider.successMessage ?? 'Account created successfully!',
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      FeedbackSnackbar.showError(
        context,
        authProvider.errorMessage ?? 'Registration failed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return ResponsiveAuthLayout(
      heroTitle: 'Join Authify',
      heroSubtitle: 'Start your journey with secure, scalable authentication.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AuthHeader(
              title: AppStrings.registerTitle,
              subtitle: AppStrings.registerSubtitle,
              icon: Icons.person_add_alt_1_rounded,
            ),
            const SizedBox(height: 28),

            // Full Name Field
            CustomTextField(
              controller: _nameController,
              label: AppStrings.fullNameLabel,
              hint: AppStrings.fullNameHint,
              prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              validator: Validators.validateName,
              onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
            ),
            const SizedBox(height: 16),

            // Email Address Field
            CustomTextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              label: AppStrings.emailLabel,
              hint: AppStrings.emailHint,
              prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: Validators.validateEmail,
              onFieldSubmitted: (_) => _phoneFocusNode.requestFocus(),
            ),
            const SizedBox(height: 16),

            // Mobile Number Field
            CustomTextField(
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              label: AppStrings.mobileLabel,
              hint: AppStrings.mobileHint,
              prefixIcon: const Icon(Icons.phone_outlined, size: 20),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.telephoneNumber],
              validator: Validators.validatePhone,
              onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
            ),
            const SizedBox(height: 16),

            // Password Field
            CustomTextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              label: AppStrings.passwordLabel,
              hint: AppStrings.passwordHint,
              obscureText: !authProvider.isRegisterPasswordVisible,
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: Validators.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  authProvider.isRegisterPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onPressed: authProvider.toggleRegisterPasswordVisibility,
                tooltip: authProvider.isRegisterPasswordVisible
                    ? 'Hide password'
                    : 'Show password',
              ),
              onFieldSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
            ),
            const SizedBox(height: 10),

            // Dynamic Password Requirements Checklist
            PasswordRequirements(password: _currentPasswordText),
            const SizedBox(height: 16),

            // Confirm Password Field
            CustomTextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              label: AppStrings.confirmPasswordLabel,
              hint: AppStrings.confirmPasswordHint,
              obscureText: !authProvider.isRegisterConfirmPasswordVisible,
              prefixIcon: const Icon(Icons.lock_clock_outlined, size: 20),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              validator: (val) => Validators.validateConfirmPassword(
                _passwordController.text,
                val,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  authProvider.isRegisterConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onPressed: authProvider.toggleRegisterConfirmPasswordVisibility,
                tooltip: authProvider.isRegisterConfirmPasswordVisible
                    ? 'Hide password'
                    : 'Show password',
              ),
              onFieldSubmitted: (_) => _handleRegister(),
            ),
            const SizedBox(height: 28),

            // Submit Button
            CustomButton(
              text: AppStrings.register,
              isLoading: authProvider.isLoading,
              onPressed: _handleRegister,
            ),
            const SizedBox(height: 24),

            // Navigation to Login
            Center(
              child: Text.rich(
                TextSpan(
                  text: AppStrings.alreadyHaveAccountPrompt,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: AppStrings.signInAction,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pop();
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
