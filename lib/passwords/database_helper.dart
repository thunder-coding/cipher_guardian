import 'package:cipher_guardian/passwords/generate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class PasswordDBConstants {
  static const tableName = 'passwords';
  static const idColumn = 'id';
  static const domainColumn = 'domain';
  static const usernameColumn = 'username';
  static const lengthColumn = 'length';
  static const passwordColumn = 'password';
  static const passwordTypeColumn = 'password_type';
  static const alphabetCaseColumn = 'alphabet_case';
  static const includeSpecialCharsColumn = 'include_special_chars';
  static const includeSpacesColumn = 'include_spaces';
  static const strictColumn = 'strict';
  static const generatedTimestampColumn = 'generated_timestamp';
  static const passwordDBName = 'passwords.db';
}

class PasswordDBHelper {
  static Database? db;
  init() async {
    if (db != null) return;
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    if (!await secureStorage.containsKey(key: 'passwordDB')) {
      String password = generatePassword(
        length: 64,
        passwordType: PasswordType.alphaNumeric,
        alphabetCase: AlphabetCase.mixed,
        includeSpecialChars: true,
        includeSpaces: true,
      );
      await secureStorage.write(key: 'passwordDB', value: password);
    }
    String password = await secureStorage.read(key: 'passwordDB') ?? '';

    db = await openDatabase(
      PasswordDBConstants.passwordDBName,
      version: 1,
      password: password,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE IF NOT EXISTS ${PasswordDBConstants.tableName} (
        ${PasswordDBConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${PasswordDBConstants.domainColumn} TEXT NOT NULL,
        ${PasswordDBConstants.usernameColumn} TEXT NOT NULL,
        ${PasswordDBConstants.lengthColumn} INTEGER NOT NULL,
        ${PasswordDBConstants.passwordColumn} TEXT NOT NULL,
        ${PasswordDBConstants.passwordTypeColumn} TEXT NOT NULL,
        ${PasswordDBConstants.alphabetCaseColumn} TEXT NOT NULL,
        ${PasswordDBConstants.includeSpecialCharsColumn} BOOLEAN NOT NULL,
        ${PasswordDBConstants.includeSpacesColumn} BOOLEAN NOT NULL,
        ${PasswordDBConstants.strictColumn} BOOLEAN NOT NULL,
        ${PasswordDBConstants.generatedTimestampColumn} INTEGER NOT NULL
      );
    ''');
      },
    );
  }

  insertPassword({
    required String domain,
    required String username,
    required int length,
    required PasswordType passwordType,
    required AlphabetCase alphabetCase,
    required bool includeSpecialChars,
    required bool includeSpaces,
    required bool strict,
    required int generatedTimestamp,
    required String password,
  }) async {
    await db!.insert(PasswordDBConstants.tableName, {
      PasswordDBConstants.domainColumn: domain,
      PasswordDBConstants.usernameColumn: username,
      PasswordDBConstants.lengthColumn: length,
      PasswordDBConstants.passwordColumn: password,
      PasswordDBConstants.passwordTypeColumn: passwordType.index,
      PasswordDBConstants.alphabetCaseColumn: alphabetCase.index,
      PasswordDBConstants.includeSpecialCharsColumn: includeSpecialChars ? 1 : 0,
      PasswordDBConstants.includeSpacesColumn: includeSpaces ? 1 : 0,
      PasswordDBConstants.strictColumn: strict ? 1 : 0,
      PasswordDBConstants.generatedTimestampColumn: generatedTimestamp,
    });
  }

  deletePassword(int id) async {
    await db?.delete(
      'passwords',
      where: '${PasswordDBConstants.idColumn} = ?',
      whereArgs: [id],
    );
  }

  updatePassword({
    required int id,
    required String domain,
    required String username,
    required int length,
    required PasswordType passwordType,
    required AlphabetCase alphabetCase,
    required bool includeSpecialChars,
    required bool includeSpaces,
    required bool strict,
    required int generatedTimestamp,
    required String password,
  }) async {
    await db!.update(
      PasswordDBConstants.tableName,
      {
        PasswordDBConstants.domainColumn: domain,
        PasswordDBConstants.usernameColumn: username,
        PasswordDBConstants.lengthColumn: length,
        PasswordDBConstants.passwordColumn: password,
        PasswordDBConstants.passwordTypeColumn: passwordType.index,
        PasswordDBConstants.alphabetCaseColumn: alphabetCase.index,
        PasswordDBConstants.includeSpecialCharsColumn: includeSpecialChars ? 1 : 0,
        PasswordDBConstants.includeSpacesColumn: includeSpaces ? 1 : 0,
        PasswordDBConstants.strictColumn: strict ? 1 : 0,
        PasswordDBConstants.generatedTimestampColumn: generatedTimestamp,
      },
      where: '${PasswordDBConstants.idColumn} = ?',
      whereArgs: [id],
    );
  }

  getElementAtPos(int pos, String searchTerm) async {
    return await db!.query(
      PasswordDBConstants.tableName,
      where:
          '${PasswordDBConstants.domainColumn} LIKE ? OR ${PasswordDBConstants.usernameColumn} LIKE ?',
      whereArgs: ['%$searchTerm%', '%$searchTerm%'],
      limit: 1,
      offset: pos,
    );
  }

  getElementAtId(int id) async {
    return await db?.query(
      PasswordDBConstants.tableName,
      where: '${PasswordDBConstants.idColumn} = ?',
      whereArgs: [id],
    );
  }

  Future<int?> getCount() async {
    return Sqflite.firstIntValue(
      await db!.rawQuery('SELECT COUNT(*) FROM ${PasswordDBConstants.tableName}'),
    );
  }

  clear() async {
    await db?.delete(PasswordDBConstants.tableName);
  }
}
