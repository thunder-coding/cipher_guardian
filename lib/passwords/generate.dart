import 'dart:math';

enum PasswordType { numeric, alphaNumeric, alpha }

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
  bool strict =
      true, // Strict Mode means atleast one lowercase, one uppercase, one digit and one special character
}) {
  // NOTE: the reason why we are not individually finding the lowercase, uppoercase, digit and special character as it would reduce the entropy of the password significantly
  String password = "";
  String allowedChars = "";

  // We are adding the special character at the end if always it is wanted
  if (strict) {
    if (includeSpecialChars) {
      length--;
    }
    if (alphabetCase == AlphabetCase.lowercase) {
      length--;
    } else if (alphabetCase == AlphabetCase.uppercase) {
      length--;
    } else if (alphabetCase == AlphabetCase.mixed) {
      length -= 2;
    }
  }

  String alphabets = "";
  if (alphabetCase == AlphabetCase.lowercase) {
    allowedChars += _lowercase;
  } else if (alphabetCase == AlphabetCase.uppercase) {
    allowedChars += _uppercase;
  } else if (alphabetCase == AlphabetCase.mixed) {
    allowedChars += _lowercase + _uppercase;
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

  // generate the password
  for (int i = 0; i < length; i++) {
    password += allowedChars[Random.secure().nextInt(allowedChars.length)];
  }

  // pick up a random special character and add it to the password at a random position
  if (strict) {
    if (includeSpecialChars) {
      String specialChar =
          _specialChars[Random.secure().nextInt(_specialChars.length)];
      var index = Random.secure().nextInt(length);
      password =
          password.substring(0, index) +
          specialChar +
          password.substring(index, password.length);
    }
    if (alphabetCase == AlphabetCase.lowercase) {
      String lowerChar = _lowercase[Random.secure().nextInt(_lowercase.length)];
      var index = Random.secure().nextInt(length);
      password =
          password.substring(0, index) +
          lowerChar +
          password.substring(index, password.length);
    } else if (alphabetCase == AlphabetCase.uppercase) {
      String upperChar = _uppercase[Random.secure().nextInt(_uppercase.length)];
      var index = Random.secure().nextInt(length);
      password =
          password.substring(0, index) +
          upperChar +
          password.substring(index, password.length);
    } else if (alphabetCase == AlphabetCase.mixed) {
      String lowerChar = _lowercase[Random.secure().nextInt(_lowercase.length)];
      String upperChar = _uppercase[Random.secure().nextInt(_uppercase.length)];
      var index = Random.secure().nextInt(length);
      password =
          password.substring(0, index) +
          lowerChar +
          password.substring(index, password.length);
      index = Random.secure().nextInt(length);
      password =
          password.substring(0, index) +
          upperChar +
          password.substring(index, password.length);
    }
  }
  return password;
}
