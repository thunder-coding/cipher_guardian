import 'package:cipher_guardian/passwords/database_helper.dart';
import 'package:cipher_guardian/passwords/generate.dart';

class PasswordStore {
  static final PasswordDBHelper dbHelper = PasswordDBHelper();

  init() async {
    await dbHelper.init();
  }

  create({
    required String domain,
    required String username,
    required int length,
    required PasswordType passwordType,
    required AlphabetCase alphabetCase,
    required bool includeSpecialChars,
    required bool includeSpaces,
    required bool strict,
  }) async {
    await dbHelper.insertPassword(
      domain: domain,
      username: username,
      length: length,
      passwordType: passwordType,
      alphabetCase: alphabetCase,
      includeSpecialChars: includeSpecialChars,
      includeSpaces: includeSpaces,
      strict: strict,
      generatedTimestamp:
          (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
      password: generatePassword(
        length: length,
        passwordType: passwordType,
        alphabetCase: alphabetCase,
        includeSpecialChars: includeSpecialChars,
        includeSpaces: includeSpaces,
        strict: strict,
      ),
    );
  }

  remove(int id) async {
    await dbHelper.deletePassword(id);
  }

  regenerate(int id) async {
    final password = await dbHelper.getElementAtId(id);
    if (password == null) return;
    await dbHelper.updatePassword(
      id: id,
      domain: password.domain,
      username: password.username,
      length: password.length,
      passwordType: password.passwordType,
      alphabetCase: password.alphabetCase,
      includeSpecialChars: password.includeSpecialChars,
      includeSpaces: password.includeSpaces,
      strict: password.strict,
      generatedTimestamp:
          (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
      password: generatePassword(
        length: password.length,
        passwordType: password.passwordType,
        alphabetCase: password.alphabetCase,
        includeSpecialChars: password.includeSpecialChars,
        includeSpaces: password.includeSpaces,
        strict: password.strict,
      ),
    );
  }

  regenerateWithNewOpts({
    required int id,
    required String domain,
    required String username,
    required int length,
    required PasswordType passwordType,
    required AlphabetCase alphabetCase,
    required bool includeSpecialChars,
    required bool includeSpaces,
    required bool strict,
  }) async {
    await dbHelper.updatePassword(
      id: id,
      domain: domain,
      username: username,
      length: length,
      passwordType: passwordType,
      alphabetCase: alphabetCase,
      includeSpecialChars: includeSpecialChars,
      includeSpaces: includeSpaces,
      strict: strict,
      password: generatePassword(
        length: length,
        passwordType: passwordType,
        alphabetCase: alphabetCase,
        includeSpecialChars: includeSpecialChars,
        includeSpaces: includeSpaces,
        strict: strict,
      ),
      generatedTimestamp:
          (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
    );
  }

  getCount() async {
    return await dbHelper.getCount();
  }

  clear() async {
    await dbHelper.clear();
  }
}
