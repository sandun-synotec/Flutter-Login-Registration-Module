import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';
import 'auth_service_interface.dart';

class _MockAccount {
  final UserModel user;
  final String password;

  _MockAccount({required this.user, required this.password});
}

class MockAuthService implements AuthServiceInterface {
  static const String _rememberMeKey = 'auth_remembered_identifier';

  final Duration simulatedDelay;
  final Map<String, _MockAccount> _accountsByEmail = {};
  final Map<String, _MockAccount> _accountsByPhone = {};

  String? _inMemoryRememberedIdentifier;

  MockAuthService({this.simulatedDelay = const Duration(milliseconds: 1200)}) {
    _seedDefaultAccounts();
  }

  void _seedDefaultAccounts() {
    final defaultUser = UserModel(
      id: 'usr_001',
      name: 'Alex Johnson',
      email: 'user@example.com',
      phone: '0771234567',
      token: 'jwt_mock_token_alex_001',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );

    final demoAccount = _MockAccount(user: defaultUser, password: 'Pass@1234');

    _accountsByEmail[defaultUser.email.toLowerCase()] = demoAccount;
    _accountsByPhone[_sanitizePhone(defaultUser.phone)] = demoAccount;
  }

  String _sanitizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }

  @override
  Future<AuthResponse> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  }) async {
    if (simulatedDelay > Duration.zero) {
      await Future.delayed(simulatedDelay);
    }

    final trimmedIdentifier = identifier.trim();
    _MockAccount? account;

    if (trimmedIdentifier.contains('@')) {
      account = _accountsByEmail[trimmedIdentifier.toLowerCase()];
    } else {
      final sanitized = _sanitizePhone(trimmedIdentifier);
      account = _accountsByPhone[sanitized];
    }

    if (account == null) {
      return AuthResponse.failure(
        message: 'No account found with this email or mobile number.',
        errorCode: 'USER_NOT_FOUND',
      );
    }

    if (account.password != password) {
      return AuthResponse.failure(
        message:
            'Incorrect password. Please verify your credentials and try again.',
        errorCode: 'WRONG_PASSWORD',
      );
    }

    if (rememberMe) {
      await setRememberedIdentifier(trimmedIdentifier);
    } else {
      await setRememberedIdentifier(null);
    }

    final activeUser = account.user.copyWith(
      token: 'jwt_mock_session_${DateTime.now().millisecondsSinceEpoch}',
    );

    return AuthResponse.success(
      user: activeUser,
      message: 'Welcome back, ${activeUser.name}!',
    );
  }

  @override
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (simulatedDelay > Duration.zero) {
      await Future.delayed(simulatedDelay);
    }

    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = _sanitizePhone(phone.trim());

    if (_accountsByEmail.containsKey(cleanEmail)) {
      return AuthResponse.failure(
        message: 'An account with this email address already exists.',
        errorCode: 'EMAIL_ALREADY_EXISTS',
      );
    }

    if (_accountsByPhone.containsKey(cleanPhone)) {
      return AuthResponse.failure(
        message: 'An account with this mobile number already exists.',
        errorCode: 'PHONE_ALREADY_EXISTS',
      );
    }

    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: cleanEmail,
      phone: phone.trim(),
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    final newAccount = _MockAccount(user: newUser, password: password);
    _accountsByEmail[cleanEmail] = newAccount;
    _accountsByPhone[cleanPhone] = newAccount;

    return AuthResponse.success(
      user: newUser,
      message: 'Account created successfully! Welcome to Authify.',
    );
  }

  @override
  Future<AuthResponse> forgotPassword({required String identifier}) async {
    if (simulatedDelay > Duration.zero) {
      await Future.delayed(simulatedDelay);
    }

    final trimmed = identifier.trim();
    _MockAccount? account;

    if (trimmed.contains('@')) {
      account = _accountsByEmail[trimmed.toLowerCase()];
    } else {
      account = _accountsByPhone[_sanitizePhone(trimmed)];
    }

    if (account == null) {
      return AuthResponse.failure(
        message: 'No registered account found with that identifier.',
        errorCode: 'USER_NOT_FOUND',
      );
    }

    return AuthResponse.success(
      user: account.user,
      message:
          'Password reset link sent to $trimmed. Please check your messages.',
    );
  }

  @override
  Future<void> logout() async {
    if (simulatedDelay > Duration.zero) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  Future<String?> getRememberedIdentifier() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_rememberMeKey) ?? _inMemoryRememberedIdentifier;
    } catch (_) {
      return _inMemoryRememberedIdentifier;
    }
  }

  @override
  Future<void> setRememberedIdentifier(String? identifier) async {
    _inMemoryRememberedIdentifier = identifier;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (identifier == null || identifier.isEmpty) {
        await prefs.remove(_rememberMeKey);
      } else {
        await prefs.setString(_rememberMeKey, identifier);
      }
    } catch (_) {
      // Ignored for environments without native shared preferences
    }
  }
}
