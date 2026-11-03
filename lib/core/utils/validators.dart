import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'^\+?[0-9]{9,15}$',
  );

  static final RegExp _nameRegExp = RegExp(
    r"^[\p{L}\s.'-]+$",
    unicode: true,
  );

  /// Validates an input that can be either an email address or a mobile phone number.
  static String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final trimmed = value.trim();
    final sanitizedPhone = trimmed.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    final isEmail = _emailRegExp.hasMatch(trimmed);
    final isPhone = _phoneRegExp.hasMatch(sanitizedPhone);

    if (!isEmail && !isPhone) {
      return AppStrings.invalidIdentifier;
    }
    return null;
  }

  /// Validates strict email format.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  /// Validates mobile phone number format.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final sanitized = value.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!_phoneRegExp.hasMatch(sanitized)) {
      return AppStrings.invalidPhone;
    }
    return null;
  }

  /// Validates full name (international characters supported, minimum 2 characters).
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return AppStrings.nameTooShort;
    }
    if (!_nameRegExp.hasMatch(trimmed)) {
      return AppStrings.nameInvalid;
    }
    return null;
  }

  /// Individual password requirement checkers.
  static bool hasMinLength(String password) => password.length >= 8;
  static bool hasUppercase(String password) => RegExp(r'[A-Z]').hasMatch(password);
  static bool hasLowercase(String password) => RegExp(r'[a-z]').hasMatch(password);
  static bool hasNumber(String password) => RegExp(r'[0-9]').hasMatch(password);
  static bool hasSpecial(String password) =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\\/]').hasMatch(password);

  /// Validates full password complexity.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (!hasMinLength(value)) {
      return AppStrings.passwordTooShort;
    }
    if (!hasUppercase(value) ||
        !hasLowercase(value) ||
        !hasNumber(value) ||
        !hasSpecial(value)) {
      return AppStrings.passwordNotStrong;
    }
    return null;
  }

  /// Validates that confirm password matches original password.
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppStrings.requiredField;
    }
    if (password != confirmPassword) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }
}
