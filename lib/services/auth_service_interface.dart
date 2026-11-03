import '../models/auth_response.dart';
import '../models/user_model.dart';

abstract class AuthServiceInterface {
  /// Signs in a user using either their registered email address or mobile number.
  Future<AuthResponse> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  });

  /// Registers a new user account.
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  /// Triggers a password reset for the provided email or mobile number.
  Future<AuthResponse> forgotPassword({
    required String identifier,
  });

  /// Ends the active user session and clears stored tokens.
  Future<void> logout();

  /// Retrieves any saved session or remembered user identifier.
  Future<String?> getRememberedIdentifier();

  /// Persists or clears the remembered user identifier.
  Future<void> setRememberedIdentifier(String? identifier);
}
