import 'dart:math';

enum PasswordType { numeric, alphaNumeric, alpha }

extension PasswordTypeExtension on PasswordType {
  String get name {
    switch (this) {
      case PasswordType.numeric:
        return 'Numeric';
      case PasswordType.alphaNumeric:
        return 'Alpha Numeric';
      case PasswordType.alpha:
        return 'Alpha';
    }
  }
}

enum AlphabetCase { lowercase, uppercase, mixed }

const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const String _digits = '0123456789';
const String _specialChars = '!@#\$%^&*()_+-=[]{}|;:\'",.<>?/`~\\';

String generatePassword({
  required int length,
  required PasswordType passwordType,
  required AlphabetCase alphabetCase,
  required bool includeSpecialChars,
  required bool includeSpaces,
  // Strict Mode means at least one lowercase, one uppercase, one digit and one special character
  bool strict = true,
}) {
  // Validate that length is sufficient for strict mode
  int minRequiredLength = 0;
  if (strict) {
    if (includeSpecialChars) minRequiredLength++;
    if (passwordType != PasswordType.numeric) {
      if (alphabetCase == AlphabetCase.mixed) {
        minRequiredLength += 2; // One lowercase + one uppercase
      } else {
        minRequiredLength++; // Either lowercase or uppercase
      }
    }
    if (passwordType == PasswordType.alphaNumeric ||
        passwordType == PasswordType.numeric) {
      minRequiredLength++; // At least one digit
    }

    if (length < minRequiredLength) {
      throw ArgumentError(
        'Password length too short for strict mode requirements',
      );
    }
  }

  String password = "";
  String allowedChars = "";

  // Build the character set
  String alphabets = "";
  if (alphabetCase == AlphabetCase.lowercase) {
    alphabets += _lowercase;
  } else if (alphabetCase == AlphabetCase.uppercase) {
    alphabets += _uppercase;
  } else if (alphabetCase == AlphabetCase.mixed) {
    alphabets += _lowercase + _uppercase;
  }

  if (includeSpaces) {
    allowedChars += " ";
  }

  if (passwordType == PasswordType.alpha) {
    allowedChars += alphabets;
  } else if (passwordType == PasswordType.numeric) {
    allowedChars += _digits;
  } else if (passwordType == PasswordType.alphaNumeric) {
    allowedChars += alphabets + _digits;
  }

  if (includeSpecialChars) {
    allowedChars += _specialChars;
  }

  // Calculate adjusted length to leave room for strict mode characters
  int adjustedLength = length;
  if (strict) {
    adjustedLength -= minRequiredLength;
  }

  // Generate the initial password with adjusted length
  for (int i = 0; i < adjustedLength; i++) {
    password += allowedChars[Random.secure().nextInt(allowedChars.length)];
  }

  // Add required characters for strict mode
  if (strict) {
    // Add special character if needed
    if (includeSpecialChars) {
      String specialChar =
          _specialChars[Random.secure().nextInt(_specialChars.length)];
      int index = Random.secure().nextInt(
        password.length + 1,
      ); // +1 allows appending at the end
      password =
          password.substring(0, index) +
          specialChar +
          (index < password.length ? password.substring(index) : "");
    }

    // Add digit for alphaNumeric or numeric password types
    if (passwordType == PasswordType.alphaNumeric ||
        passwordType == PasswordType.numeric) {
      String digitChar = _digits[Random.secure().nextInt(_digits.length)];
      int index = Random.secure().nextInt(password.length + 1);
      password =
          password.substring(0, index) +
          digitChar +
          (index < password.length ? password.substring(index) : "");
    }

    // Add lowercase/uppercase based on alphabetCase
    if (passwordType != PasswordType.numeric) {
      if (alphabetCase == AlphabetCase.lowercase ||
          alphabetCase == AlphabetCase.mixed) {
        String lowerChar =
            _lowercase[Random.secure().nextInt(_lowercase.length)];
        int index = Random.secure().nextInt(password.length + 1);
        password =
            password.substring(0, index) +
            lowerChar +
            (index < password.length ? password.substring(index) : "");
      }

      if (alphabetCase == AlphabetCase.uppercase ||
          alphabetCase == AlphabetCase.mixed) {
        String upperChar =
            _uppercase[Random.secure().nextInt(_uppercase.length)];
        int index = Random.secure().nextInt(password.length + 1);
        password =
            password.substring(0, index) +
            upperChar +
            (index < password.length ? password.substring(index) : "");
      }
    }
  }

  return password;
}
