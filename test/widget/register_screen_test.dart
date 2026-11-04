import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login_registration_module/core/constants/app_strings.dart';
import 'package:flutter_login_registration_module/core/theme/app_theme.dart';
import 'package:flutter_login_registration_module/providers/auth_provider.dart';
import 'package:flutter_login_registration_module/screens/home_screen.dart';
import 'package:flutter_login_registration_module/screens/login_screen.dart';
import 'package:flutter_login_registration_module/screens/register_screen.dart';
import 'package:flutter_login_registration_module/services/mock_auth_service.dart';
import 'package:flutter_login_registration_module/widgets/auth_header.dart';

Widget createTestWidget() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(
          authService: MockAuthService(simulatedDelay: Duration.zero),
        ),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: '/register',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RegisterScreen Widget Tests', () {
    testWidgets('renders all registration form elements', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(AuthHeader, AppStrings.registerTitle),
        findsOneWidget,
      );
      expect(find.text(AppStrings.fullNameLabel), findsOneWidget);
      expect(find.text(AppStrings.emailLabel), findsOneWidget);
      expect(find.text(AppStrings.mobileLabel), findsOneWidget);
      expect(find.text(AppStrings.passwordLabel), findsOneWidget);
      expect(find.text(AppStrings.confirmPasswordLabel), findsOneWidget);
      expect(find.text(AppStrings.passwordRequirementHeader), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, AppStrings.register),
        findsOneWidget,
      );
    });

    testWidgets('shows validation errors when registering with empty fields', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final registerButton = find.widgetWithText(
        ElevatedButton,
        AppStrings.register,
      );
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.requiredField), findsWidgets);
    });

    testWidgets('detects mismatched password and confirm password', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      // Field indices: 0: Name, 1: Email, 2: Phone, 3: Password, 4: Confirm Password
      await tester.enterText(textFields.at(0), 'Jane Doe');
      await tester.enterText(textFields.at(1), 'jane@example.com');
      await tester.enterText(textFields.at(2), '0712345678');
      await tester.enterText(textFields.at(3), 'Pass@1234');
      await tester.enterText(textFields.at(4), 'Pass@9999');
      await tester.pumpAndSettle();

      final registerButton = find.widgetWithText(
        ElevatedButton,
        AppStrings.register,
      );
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.passwordsDoNotMatch), findsOneWidget);
    });

    testWidgets('successfully registers and navigates to home', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Jane Doe');
      await tester.enterText(textFields.at(1), 'jane.doe@example.com');
      await tester.enterText(textFields.at(2), '0712345678');
      await tester.enterText(textFields.at(3), 'Pass@1234');
      await tester.enterText(textFields.at(4), 'Pass@1234');
      await tester.pumpAndSettle();

      final registerButton = find.widgetWithText(
        ElevatedButton,
        AppStrings.register,
      );
      await tester.tap(registerButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Authify Dashboard'), findsOneWidget);
      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('jane.doe@example.com'), findsOneWidget);
    });
  });
}
