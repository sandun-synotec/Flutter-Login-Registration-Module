import 'user_model.dart';

class AuthResponse {
  final bool isSuccess;
  final String message;
  final UserModel? user;
  final String? errorCode;

  const AuthResponse({
    required this.isSuccess,
    required this.message,
    this.user,
    this.errorCode,
  });

  factory AuthResponse.success({
    required UserModel user,
    String message = 'Operation successful',
  }) {
    return AuthResponse(isSuccess: true, message: message, user: user);
  }

  factory AuthResponse.failure({required String message, String? errorCode}) {
    return AuthResponse(
      isSuccess: false,
      message: message,
      errorCode: errorCode,
    );
  }

  @override
  String toString() {
    return 'AuthResponse(isSuccess: $isSuccess, message: $message, user: $user, errorCode: $errorCode)';
  }
}
