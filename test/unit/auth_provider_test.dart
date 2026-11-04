import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_login_registration_module/providers/auth_provider.dart';
import 'package:flutter_login_registration_module/services/mock_auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthProvider authProvider;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService(simulatedDelay: Duration.zero);
    authProvider = AuthProvider(authService: mockAuthService);
  });

  group('AuthProvider State Management', () {
    test('initial state is unauthenticated and not loading', () {
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, false);
      expect(authProvider.errorMessage, isNull);
    });

    test('toggles password visibility correctly', () {
      expect(authProvider.isLoginPasswordVisible, false);
      authProvider.toggleLoginPasswordVisibility();
      expect(authProvider.isLoginPasswordVisible, true);
      authProvider.toggleLoginPasswordVisibility();
      expect(authProvider.isLoginPasswordVisible, false);

      expect(authProvider.isRegisterPasswordVisible, false);
      authProvider.toggleRegisterPasswordVisibility();
      expect(authProvider.isRegisterPasswordVisible, true);

      expect(authProvider.isRegisterConfirmPasswordVisible, false);
      authProvider.toggleRegisterConfirmPasswordVisibility();
      expect(authProvider.isRegisterConfirmPasswordVisible, true);
    });

    test('updates rememberMe state', () {
      expect(authProvider.rememberMe, false);
      authProvider.setRememberMe(true);
      expect(authProvider.rememberMe, true);
    });

    test('successful login sets currentUser and authenticates', () async {
      final success = await authProvider.login('user@example.com', 'Pass@1234');

      expect(success, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.currentUser, isNotNull);
      expect(authProvider.currentUser!.email, 'user@example.com');
      expect(authProvider.errorMessage, isNull);
      expect(authProvider.successMessage, isNotNull);
    });

    test('failed login sets errorMessage and does not authenticate', () async {
      final success = await authProvider.login(
        'user@example.com',
        'WrongPass!',
      );

      expect(success, false);
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.currentUser, isNull);
      expect(authProvider.errorMessage, isNotNull);
    });

    test('successful registration authenticates user', () async {
      final success = await authProvider.register(
        name: 'Provider Test User',
        email: 'provider.test@example.com',
        phone: '0779998888',
        password: 'Pass@1234',
      );

      expect(success, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.currentUser!.name, 'Provider Test User');
    });

    test('logout resets user and auth state', () async {
      await authProvider.login('user@example.com', 'Pass@1234');
      expect(authProvider.isAuthenticated, true);

      await authProvider.logout();
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.currentUser, isNull);
    });
  });
}
