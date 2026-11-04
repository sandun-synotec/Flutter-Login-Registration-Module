import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service_interface.dart';
import '../services/mock_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthServiceInterface _authService;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool _rememberMe = false;
  String? _savedIdentifier;

  // Visibility toggles for form fields
  bool _isLoginPasswordVisible = false;
  bool _isRegisterPasswordVisible = false;
  bool _isRegisterConfirmPasswordVisible = false;

  AuthProvider({AuthServiceInterface? authService})
    : _authService = authService ?? MockAuthService() {
    loadSavedSession();
  }

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  bool get rememberMe => _rememberMe;
  String? get savedIdentifier => _savedIdentifier;

  bool get isLoginPasswordVisible => _isLoginPasswordVisible;
  bool get isRegisterPasswordVisible => _isRegisterPasswordVisible;
  bool get isRegisterConfirmPasswordVisible =>
      _isRegisterConfirmPasswordVisible;

  /// Loads remembered login credentials or active preferences on start.
  Future<void> loadSavedSession() async {
    try {
      final remembered = await _authService.getRememberedIdentifier();
      if (remembered != null && remembered.isNotEmpty) {
        _savedIdentifier = remembered;
        _rememberMe = true;
        notifyListeners();
      }
    } catch (_) {
      // Ignored if platform storage is not ready yet
    }
  }

  void toggleLoginPasswordVisibility() {
    _isLoginPasswordVisible = !_isLoginPasswordVisible;
    notifyListeners();
  }

  void toggleRegisterPasswordVisibility() {
    _isRegisterPasswordVisible = !_isRegisterPasswordVisible;
    notifyListeners();
  }

  void toggleRegisterConfirmPasswordVisibility() {
    _isRegisterConfirmPasswordVisible = !_isRegisterConfirmPasswordVisible;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Attempts to sign in the user.
  Future<bool> login(String identifier, String password) async {
    _setLoading(true);
    _clearErrors();

    try {
      final response = await _authService.login(
        identifier: identifier,
        password: password,
        rememberMe: _rememberMe,
      );

      _setLoading(false);

      if (response.isSuccess) {
        _currentUser = response.user;
        _successMessage = response.message;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  /// Registers a new user.
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _clearErrors();

    try {
      final response = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      _setLoading(false);

      if (response.isSuccess) {
        _currentUser = response.user;
        _successMessage = response.message;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _errorMessage =
          'Registration failed due to a network error. Please try again.';
      notifyListeners();
      return false;
    }
  }

  /// Requests password reset.
  Future<bool> forgotPassword(String identifier) async {
    _setLoading(true);
    _clearErrors();

    try {
      final response = await _authService.forgotPassword(
        identifier: identifier,
      );
      _setLoading(false);

      if (response.isSuccess) {
        _successMessage = response.message;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Unable to send reset instructions. Please try again.';
      notifyListeners();
      return false;
    }
  }

  /// Signs the user out.
  Future<void> logout() async {
    _setLoading(true);
    await _authService.logout();
    _currentUser = null;
    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearErrors() {
    _errorMessage = null;
    _successMessage = null;
  }
}
