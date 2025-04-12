import 'package:cipher_guardian/passwords/generate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class PasswordDBHelper {
  static const _tableName = 'passwords';
  static const _idColumn = 'id';
  static const _domainColumn = 'domain';
  static const _usernameColumn = 'username';
  static const _lengthColumn = 'length';
  static const _passwordColumn = 'password';
  static const _passwordTypeColumn = 'password_type';
  static const _alphabetCaseColumn = 'alphabet_case';
  static const _includeSpecialCharsColumn = 'include_special_chars';
  static const _includeSpacesColumn = 'include_spaces';
  static const _strictColumn = 'strict';
  static const _generatedTimestampColumn = 'generated_timestamp';
  static const _passwordDBName = 'passwords.db';
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
      _passwordDBName,
      version: 1,
      password: password,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        $_idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
        $_domainColumn TEXT NOT NULL,
        $_usernameColumn TEXT NOT NULL,
        $_lengthColumn INTEGER NOT NULL,
        $_passwordColumn TEXT NOT NULL,
        $_passwordTypeColumn TEXT NOT NULL,
        $_alphabetCaseColumn TEXT NOT NULL,
        $_includeSpecialCharsColumn BOOLEAN NOT NULL,
        $_includeSpacesColumn BOOLEAN NOT NULL,
        $_strictColumn BOOLEAN NOT NULL,
        $_generatedTimestampColumn INTEGER NOT NULL
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
    await db!.insert(_tableName, {
      _domainColumn: domain,
      _usernameColumn: username,
      _lengthColumn: length,
      _passwordColumn: password,
      _passwordTypeColumn: passwordType.index,
      _alphabetCaseColumn: alphabetCase.index,
      _includeSpecialCharsColumn: includeSpecialChars,
      _includeSpacesColumn: includeSpaces,
      _strictColumn: strict,
      _generatedTimestampColumn: generatedTimestamp,
    });
  }

  deletePassword(int id) async {
    await db?.delete('passwords', where: '$_idColumn = ?', whereArgs: [id]);
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
      _tableName,
      {
        _domainColumn: domain,
        _usernameColumn: username,
        _lengthColumn: length,
        _passwordColumn: password,
        _passwordTypeColumn: passwordType.index,
        _alphabetCaseColumn: alphabetCase.index,
        _includeSpecialCharsColumn: includeSpecialChars,
        _includeSpacesColumn: includeSpaces,
        _strictColumn: strict,
        _generatedTimestampColumn: generatedTimestamp,
      },
      where: '$_idColumn = ?',
      whereArgs: [id],
    );
  }

  getElementAtPos(int pos, String searchTerm) async {
    return await db!.query(
      _tableName,
      where: '$_domainColumn LIKE ? OR $_usernameColumn LIKE ?',
      whereArgs: ['%$searchTerm%', '%$searchTerm%'],
      limit: 1,
      offset: pos,
    );
  }

  getElementAtId(int id) async {
    return await db?.query(
      _tableName,
      where: '$_idColumn = ?',
      whereArgs: [id],
    );
  }

  Future<int?> getCount() async {
    return Sqflite.firstIntValue(
      await db!.rawQuery('SELECT COUNT(*) FROM $_tableName'),
    );
  }

  clear() async {
    await db?.delete(_tableName);
  }
}
