import 'package:cipher_guardian/passwords/database_helper.dart';
import 'package:cipher_guardian/passwords/generate.dart';

class Entry {
  final int id;
  final String domain;
  final String username;
  final String password;
  final int length;
  final PasswordType passwordType;
  final AlphabetCase alphabetCase;
  final bool includeSpecialChars;
  final bool includeSpaces;
  final bool strict;
  final int generatedTimestamp;
  Entry({
    required this.id,
    required this.domain,
    required this.username,
    required this.password,
    required this.length,
    required this.passwordType,
    required this.alphabetCase,
    required this.includeSpecialChars,
    required this.includeSpaces,
    required this.strict,
    required this.generatedTimestamp,
  });
}

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

  Future<Entry> getElementAtPos(int pos, String searchTerm) async {
    List<Map> q = await dbHelper.getElementAtPos(pos, searchTerm);
    Entry entry = Entry(
      id: q[0][PasswordDBConstants.idColumn],
      domain: q[0][PasswordDBConstants.domainColumn],
      username: q[0][PasswordDBConstants.usernameColumn],
      password: q[0][PasswordDBConstants.passwordColumn],
      length: q[0][PasswordDBConstants.lengthColumn],
      passwordType:
          PasswordType.values[q[0][PasswordDBConstants.passwordTypeColumn]],
      alphabetCase:
          AlphabetCase.values[q[0][PasswordDBConstants.alphabetCaseColumn]],
      includeSpecialChars:
          q[0][PasswordDBConstants.includeSpecialCharsColumn] == 1,
      includeSpaces: q[0][PasswordDBConstants.includeSpacesColumn] == 1,
      strict: q[0][PasswordDBConstants.strictColumn] == 1,
      generatedTimestamp: q[0][PasswordDBConstants.generatedTimestampColumn],
    );
    return Future.value(entry);
  }

  getCount() async {
    return await dbHelper.getCount();
  }

  clear() async {
    await dbHelper.clear();
  }
}
