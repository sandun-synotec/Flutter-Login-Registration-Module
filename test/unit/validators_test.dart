import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_login_registration_module/core/utils/validators.dart';
import 'package:flutter_login_registration_module/core/constants/app_strings.dart';

void main() {
  group('Validators - validateIdentifier', () {
    test('returns requiredField when null or empty', () {
      expect(Validators.validateIdentifier(null), AppStrings.requiredField);
      expect(Validators.validateIdentifier('   '), AppStrings.requiredField);
    });

    test('accepts valid email addresses', () {
      expect(Validators.validateIdentifier('user@example.com'), isNull);
      expect(Validators.validateIdentifier('john.doe@sub.domain.co'), isNull);
    });

    test('accepts valid mobile phone numbers', () {
      expect(Validators.validateIdentifier('0771234567'), isNull);
      expect(Validators.validateIdentifier('+94771234567'), isNull);
      expect(Validators.validateIdentifier('1234567890'), isNull);
    });

    test('rejects invalid identifiers', () {
      expect(Validators.validateIdentifier('invalid-input'), AppStrings.invalidIdentifier);
      expect(Validators.validateIdentifier('1234'), AppStrings.invalidIdentifier);
      expect(Validators.validateIdentifier('user@'), AppStrings.invalidIdentifier);
    });
  });

  group('Validators - validateEmail', () {
    test('accepts valid emails', () {
      expect(Validators.validateEmail('test@domain.com'), isNull);
      expect(Validators.validateEmail('user.name+tag@example.org'), isNull);
    });

    test('rejects invalid emails', () {
      expect(Validators.validateEmail(null), AppStrings.requiredField);
      expect(Validators.validateEmail('plainaddress'), AppStrings.invalidEmail);
      expect(Validators.validateEmail('@missingusername.com'), AppStrings.invalidEmail);
      expect(Validators.validateEmail('user@domain'), AppStrings.invalidEmail);
    });
  });

  group('Validators - validatePhone', () {
    test('accepts valid phone formats', () {
      expect(Validators.validatePhone('0771234567'), isNull);
      expect(Validators.validatePhone('+94 77 123 4567'), isNull);
      expect(Validators.validatePhone('1234567890'), isNull);
    });

    test('rejects invalid phone formats', () {
      expect(Validators.validatePhone(null), AppStrings.requiredField);
      expect(Validators.validatePhone('123'), AppStrings.invalidPhone);
      expect(Validators.validatePhone('phone123456'), AppStrings.invalidPhone);
    });
  });

  group('Validators - validateName', () {
    test('accepts valid names including unicode and accents', () {
      expect(Validators.validateName('John Doe'), isNull);
      expect(Validators.validateName("O'Connor"), isNull);
      expect(Validators.validateName('Mary-Jane'), isNull);
      expect(Validators.validateName('René Descartes'), isNull);
    });

    test('rejects short or empty names', () {
      expect(Validators.validateName(null), AppStrings.requiredField);
      expect(Validators.validateName(''), AppStrings.requiredField);
      expect(Validators.validateName('A'), AppStrings.nameTooShort);
    });

    test('rejects names with numbers or symbols', () {
      expect(Validators.validateName('User123'), AppStrings.nameInvalid);
      expect(Validators.validateName('John @Doe'), AppStrings.nameInvalid);
    });
  });

  group('Validators - validatePassword and rules', () {
    test('validates password rule components correctly', () {
      expect(Validators.hasMinLength('Pass1!'), false);
      expect(Validators.hasMinLength('Password123!'), true);

      expect(Validators.hasUppercase('password1!'), false);
      expect(Validators.hasUppercase('Password1!'), true);

      expect(Validators.hasLowercase('PASSWORD1!'), false);
      expect(Validators.hasLowercase('Password1!'), true);

      expect(Validators.hasNumber('Password!'), false);
      expect(Validators.hasNumber('Password1!'), true);

      expect(Validators.hasSpecial('Password123'), false);
      expect(Validators.hasSpecial('Password123!'), true);
    });

    test('accepts strong compliant password', () {
      expect(Validators.validatePassword('Pass@1234'), isNull);
      expect(Validators.validatePassword('Secure#2026Strong'), isNull);
    });

    test('rejects non-compliant passwords', () {
      expect(Validators.validatePassword(null), AppStrings.requiredField);
      expect(Validators.validatePassword('short'), AppStrings.passwordTooShort);
      expect(Validators.validatePassword('alllowercase1!'), AppStrings.passwordNotStrong);
      expect(Validators.validatePassword('ALLUPPERCASE1!'), AppStrings.passwordNotStrong);
      expect(Validators.validatePassword('NoSpecialChar123'), AppStrings.passwordNotStrong);
      expect(Validators.validatePassword('NoNumbersHere!'), AppStrings.passwordNotStrong);
    });
  });

  group('Validators - validateConfirmPassword', () {
    test('returns null when passwords match', () {
      expect(Validators.validateConfirmPassword('Pass@1234', 'Pass@1234'), isNull);
    });

    test('returns error when mismatch or empty', () {
      expect(Validators.validateConfirmPassword('Pass@1234', null), AppStrings.requiredField);
      expect(Validators.validateConfirmPassword('Pass@1234', ''), AppStrings.requiredField);
      expect(Validators.validateConfirmPassword('Pass@1234', 'Pass@12345'), AppStrings.passwordsDoNotMatch);
    });
  });
}
