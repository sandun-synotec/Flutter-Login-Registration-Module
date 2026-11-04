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

Widget createTestWidget({AuthProvider? provider}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(
        create: (_) =>
            provider ??
            AuthProvider(
              authService: MockAuthService(simulatedDelay: Duration.zero),
            ),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
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

  group('LoginScreen Widget Tests', () {
    testWidgets('renders all key elements and inputs correctly', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.loginTitle), findsOneWidget);
      expect(find.text(AppStrings.emailOrMobileLabel), findsOneWidget);
      expect(find.text(AppStrings.passwordLabel), findsOneWidget);
      expect(find.text(AppStrings.rememberMe), findsOneWidget);
      expect(find.text(AppStrings.forgotPassword), findsOneWidget);
      expect(find.text(AppStrings.signIn), findsOneWidget);
      expect(find.textContaining(AppStrings.signUpAction), findsOneWidget);
    });

    testWidgets('triggers validation on empty input submission', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final signInButton = find.widgetWithText(
        ElevatedButton,
        AppStrings.signIn,
      );
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.requiredField), findsWidgets);
    });

    testWidgets('toggles password visibility when icon tapped', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final visibilityButton = find.byTooltip('Show password');
      expect(visibilityButton, findsOneWidget);

      await tester.tap(visibilityButton);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Hide password'), findsOneWidget);
    });

    testWidgets(
      'autofill button populates demo credentials and logs in successfully',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final autofillBtn = find.text('Autofill');
        expect(autofillBtn, findsOneWidget);
        await tester.tap(autofillBtn);
        await tester.pumpAndSettle();

        expect(find.text('user@example.com'), findsOneWidget);

        final signInButton = find.widgetWithText(
          ElevatedButton,
          AppStrings.signIn,
        );
        await tester.tap(signInButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        // Navigated to Home screen
        expect(find.text('Authify Dashboard'), findsOneWidget);
        expect(find.text('Alex Johnson'), findsOneWidget);
      },
    );

    testWidgets('opens Forgot Password dialog when tapped', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final forgotPassBtn = find.text(AppStrings.forgotPassword);
      await tester.tap(forgotPassBtn);
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.forgotPasswordTitle), findsOneWidget);
      expect(find.text(AppStrings.sendResetLink), findsOneWidget);
    });
  });
}
