import 'package:flutter_test/flutter_test.dart';
import 'package:cipher_guardian/passwords/generate.dart';

void main() {
  group('Password Generation Test', () {
    test('Generate Password with Strict Mode', () {
      // Test case for strict mode
      String password = generatePassword(
        length: 12,
        passwordType: PasswordType.alphaNumeric,
        alphabetCase: AlphabetCase.mixed,
        includeSpecialChars: true,
        includeSpaces: false,
        strict: true,
      );
      expect(password.length, 12);
      expect(password.contains(RegExp(r'[a-z]')), isTrue);
      expect(password.contains(RegExp(r'[A-Z]')), isTrue);
      expect(password.contains(RegExp(r'[0-9]')), isTrue);
      expect(password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{};":\\|,.<>\/?`~]')), isTrue);
      expect(password.contains(' '), isFalse);
    });
    test('Generate Password without Strict Mode', () {
      // Test case for non-strict mode
      String password = generatePassword(
        length: 12,
        passwordType: PasswordType.alphaNumeric,
        alphabetCase: AlphabetCase.mixed,
        includeSpecialChars: false,
        includeSpaces: false,
        strict: false,
      );
      expect(password.length, 12);
      expect(password.contains(RegExp(r'[a-z]')), isTrue);
      expect(password.contains(RegExp(r'[A-Z]')), isTrue);
      expect(password.contains(RegExp(r'[0-9]')), isTrue);
      expect(password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{};":\\|,.<>\/?`~]')), isFalse);
      expect(password.contains(' '), isFalse);
    });
    test('Generate Numeric Password', () {
      // Test case for numeric password
      String password = generatePassword(
        length: 10,
        passwordType: PasswordType.numeric,
        alphabetCase: AlphabetCase.lowercase,
        includeSpecialChars: false,
        includeSpaces: false,
        strict: false,
      );
      expect(password.length, 10);
      expect(password.contains(RegExp(r'[0-9]')), isTrue);
      expect(password.contains(RegExp(r'[a-z]')), isFalse);
      expect(password.contains(RegExp(r'[A-Z]')), isFalse);
      expect(password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{};":\\|,.<>\/?`~]')), isFalse);
      expect(password.contains(' '), isFalse);
    });
    test('Generate Alphabetic Password', () {
      // Test case for alphabetic password
      String password = generatePassword(
        length: 10,
        passwordType: PasswordType.alpha,
        alphabetCase: AlphabetCase.lowercase,
        includeSpecialChars: false,
        includeSpaces: false,
        strict: false,
      );
      expect(password.length, 10);
      expect(password.contains(RegExp(r'[a-z]')), isTrue);
      expect(password.contains(RegExp(r'[A-Z]')), isFalse);
      expect(password.contains(RegExp(r'[0-9]')), isFalse);
      expect(password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{};":\\|,.<>\/?`~]')), isFalse);
      expect(password.contains(' '), isFalse);
    });
  });
}
