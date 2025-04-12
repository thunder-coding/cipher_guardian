import 'package:cipher_guardian/passwords/database_helper.dart';
import 'package:cipher_guardian/passwords/generate.dart';

password_new_handler({
  required String domain,
  required String username,
  required String password,
  required PasswordType passwordType,
  required AlphabetCase alphabetCase,
  required bool includeSpecialChars,
  required bool includeSpaces,
  required bool generatedPassword,
  required bool strict,
  required int length,
}) async {
  PasswordDBHelper dbHelper = PasswordDBHelper();
  await dbHelper.init();
  dbHelper.insertPassword(
    domain: domain,
    username: username,
    length: length,
    passwordType: passwordType,
    alphabetCase: alphabetCase,
    includeSpecialChars: includeSpecialChars,
    includeSpaces: includeSpaces,
    strict: strict,
    generatedTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    password:
        generatedPassword
            ? generatePassword(
              length: length,
              passwordType: passwordType,
              alphabetCase: alphabetCase,
              includeSpecialChars: includeSpecialChars,
              includeSpaces: includeSpaces,
              strict: strict,
            )
            : password,
  );
}
