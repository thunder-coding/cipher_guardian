import 'package:cipher_guardian/passwords/generate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class Constants {
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
      Constants.passwordDBName,
      version: 1,
      password: password,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.tableName} (
        ${Constants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Constants.domainColumn} TEXT NOT NULL,
        ${Constants.usernameColumn} TEXT NOT NULL,
        ${Constants.lengthColumn} INTEGER NOT NULL,
        ${Constants.passwordColumn} TEXT NOT NULL,
        ${Constants.passwordTypeColumn} TEXT NOT NULL,
        ${Constants.alphabetCaseColumn} TEXT NOT NULL,
        ${Constants.includeSpecialCharsColumn} BOOLEAN NOT NULL,
        ${Constants.includeSpacesColumn} BOOLEAN NOT NULL,
        ${Constants.strictColumn} BOOLEAN NOT NULL,
        ${Constants.generatedTimestampColumn} INTEGER NOT NULL
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
    await db!.insert(Constants.tableName, {
      Constants.domainColumn: domain,
      Constants.usernameColumn: username,
      Constants.lengthColumn: length,
      Constants.passwordColumn: password,
      Constants.passwordTypeColumn: passwordType.index,
      Constants.alphabetCaseColumn: alphabetCase.index,
      Constants.includeSpecialCharsColumn: includeSpecialChars ? 1 : 0,
      Constants.includeSpacesColumn: includeSpaces ? 1 : 0,
      Constants.strictColumn: strict ? 1 : 0,
      Constants.generatedTimestampColumn: generatedTimestamp,
    });
  }

  deletePassword(int id) async {
    await db?.delete(
      'passwords',
      where: '${Constants.idColumn} = ?',
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
      Constants.tableName,
      {
        Constants.domainColumn: domain,
        Constants.usernameColumn: username,
        Constants.lengthColumn: length,
        Constants.passwordColumn: password,
        Constants.passwordTypeColumn: passwordType.index,
        Constants.alphabetCaseColumn: alphabetCase.index,
        Constants.includeSpecialCharsColumn: includeSpecialChars ? 1 : 0,
        Constants.includeSpacesColumn: includeSpaces ? 1 : 0,
        Constants.strictColumn: strict ? 1 : 0,
        Constants.generatedTimestampColumn: generatedTimestamp,
      },
      where: '${Constants.idColumn} = ?',
      whereArgs: [id],
    );
  }

  getElementAtPos(int pos, String searchTerm) async {
    return await db!.query(
      Constants.tableName,
      where:
          '${Constants.domainColumn} LIKE ? OR ${Constants.usernameColumn} LIKE ?',
      whereArgs: ['%$searchTerm%', '%$searchTerm%'],
      limit: 1,
      offset: pos,
    );
  }

  getElementAtId(int id) async {
    return await db?.query(
      Constants.tableName,
      where: '${Constants.idColumn} = ?',
      whereArgs: [id],
    );
  }

  Future<int?> getCount() async {
    return Sqflite.firstIntValue(
      await db!.rawQuery('SELECT COUNT(*) FROM ${Constants.tableName}'),
    );
  }

  clear() async {
    await db?.delete(Constants.tableName);
  }
}
