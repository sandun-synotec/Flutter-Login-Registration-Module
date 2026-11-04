import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_login_registration_module/services/mock_auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService(simulatedDelay: Duration.zero);
  });

  group('MockAuthService - login', () {
    test('succeeds with default seeded email and password', () async {
      final response = await authService.login(
        identifier: 'user@example.com',
        password: 'Pass@1234',
      );

      expect(response.isSuccess, true);
      expect(response.user, isNotNull);
      expect(response.user!.email, 'user@example.com');
      expect(response.user!.name, 'Alex Johnson');
      expect(response.user!.token, isNotNull);
    });

    test('succeeds with default seeded phone number and password', () async {
      final response = await authService.login(
        identifier: '0771234567',
        password: 'Pass@1234',
      );

      expect(response.isSuccess, true);
      expect(response.user, isNotNull);
      expect(response.user!.phone, '0771234567');
    });

    test('fails when user not found', () async {
      final response = await authService.login(
        identifier: 'nonexistent@example.com',
        password: 'Pass@1234',
      );

      expect(response.isSuccess, false);
      expect(response.errorCode, 'USER_NOT_FOUND');
    });

    test('fails when password is incorrect', () async {
      final response = await authService.login(
        identifier: 'user@example.com',
        password: 'WrongPassword!',
      );

      expect(response.isSuccess, false);
      expect(response.errorCode, 'WRONG_PASSWORD');
    });
  });

  group('MockAuthService - register', () {
    test('successfully registers new user', () async {
      final response = await authService.register(
        name: 'New User',
        email: 'newuser@example.com',
        phone: '0711112222',
        password: 'NewPass#2026',
      );

      expect(response.isSuccess, true);
      expect(response.user, isNotNull);
      expect(response.user!.email, 'newuser@example.com');

      // Now verify new user can log in
      final loginResp = await authService.login(
        identifier: 'newuser@example.com',
        password: 'NewPass#2026',
      );
      expect(loginResp.isSuccess, true);
      expect(loginResp.user!.name, 'New User');
    });

    test('fails when email already exists', () async {
      final response = await authService.register(
        name: 'Duplicate Email',
        email: 'user@example.com',
        phone: '0722223333',
        password: 'Pass@1234',
      );

      expect(response.isSuccess, false);
      expect(response.errorCode, 'EMAIL_ALREADY_EXISTS');
    });

    test('fails when phone number already exists', () async {
      final response = await authService.register(
        name: 'Duplicate Phone',
        email: 'unique@example.com',
        phone: '0771234567',
        password: 'Pass@1234',
      );

      expect(response.isSuccess, false);
      expect(response.errorCode, 'PHONE_ALREADY_EXISTS');
    });
  });

  group('MockAuthService - forgotPassword', () {
    test('succeeds for existing user', () async {
      final response = await authService.forgotPassword(
        identifier: 'user@example.com',
      );
      expect(response.isSuccess, true);
    });

    test('fails for unknown identifier', () async {
      final response = await authService.forgotPassword(
        identifier: 'unknown@example.com',
      );
      expect(response.isSuccess, false);
      expect(response.errorCode, 'USER_NOT_FOUND');
    });
  });

  group('MockAuthService - rememberMe', () {
    test('sets and gets remembered identifier', () async {
      await authService.setRememberedIdentifier('saved@example.com');
      final saved = await authService.getRememberedIdentifier();
      expect(saved, 'saved@example.com');

      await authService.setRememberedIdentifier(null);
      final cleared = await authService.getRememberedIdentifier();
      expect(cleared, isNull);
    });
  });
}
