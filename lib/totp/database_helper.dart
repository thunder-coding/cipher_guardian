import 'package:cipher_guardian/passwords/generate.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class TOTPDBConstants {
  static const tableName = 'totp';
  static const idColumn = 'id';
  static const domainColumn = 'domain';
  static const usernameColumn = 'username';
  static const secretColumn = 'secret';
  static const algorithmColumn = 'algorithm';
  static const typeColumn = 'type'; // HOTP/TOTP
  static const digitsColumn = 'digits';
  static const periodColumn = 'period';
  static const createdTimestampColumn = 'created_timestamp';
  static const counterColumn = 'counter';
}

class TOTPDBHelper {
  static Database? db;
  init() async {
    if (db != null) return;
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    if (!await secureStorage.containsKey(key: 'totpDB')) {
      String password = generatePassword(
        length: 64,
        passwordType: PasswordType.alphaNumeric,
        alphabetCase: AlphabetCase.mixed,
        includeSpecialChars: true,
        includeSpaces: true,
      );
      await secureStorage.write(key: 'totpDB', value: password);
    }
    String password = await secureStorage.read(key: 'totpDB') ?? '';
    db = await openDatabase(
      TOTPDBConstants.tableName,
      version: 1,
      password: password,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS ${TOTPDBConstants.tableName} (
          ${TOTPDBConstants.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${TOTPDBConstants.domainColumn} TEXT NOT NULL,
          ${TOTPDBConstants.usernameColumn} TEXT NOT NULL,
          ${TOTPDBConstants.secretColumn} TEXT NOT NULL,
          ${TOTPDBConstants.algorithmColumn} TEXT NOT NULL,
          ${TOTPDBConstants.typeColumn} TEXT NOT NULL,
          ${TOTPDBConstants.digitsColumn} INTEGER NOT NULL,
          ${TOTPDBConstants.periodColumn} INTEGER NOT NULL,
          ${TOTPDBConstants.createdTimestampColumn} INTEGER NOT NULL,
          ${TOTPDBConstants.counterColumn} INTEGER
        );
      ''');
      },
    );
  }

  insertTOTP({
    required String domain,
    required String username,
    required String secret,
    required String algorithm,
    required String type,
    required int digits,
    required int period,
    required int createdTimestamp,
    required int counter,
  }) async {
    await db!.insert(TOTPDBConstants.tableName, {
      TOTPDBConstants.domainColumn: domain,
      TOTPDBConstants.usernameColumn: username,
      TOTPDBConstants.secretColumn: secret,
      TOTPDBConstants.algorithmColumn: algorithm,
      TOTPDBConstants.typeColumn: type,
      TOTPDBConstants.digitsColumn: digits,
      TOTPDBConstants.periodColumn: period,
      TOTPDBConstants.createdTimestampColumn: createdTimestamp,
      TOTPDBConstants.counterColumn: counter,
    });
  }

  deleteTOTP(int id) async {
    await db!.delete(
      TOTPDBConstants.tableName,
      where: '${TOTPDBConstants.idColumn} = ?',
      whereArgs: [id],
    );
  }

  incrementTOTPCounter(int id) async {
    await db!.execute(
      '''
      UPDATE ${TOTPDBConstants.tableName}
      SET ${TOTPDBConstants.counterColumn} = ${TOTPDBConstants.counterColumn} + 1
      WHERE ${TOTPDBConstants.idColumn} = ?
    ''',
      [id],
    );
  }

  getElementAtPos(int pos, String searchTerm) async {
    return await db!.query(
      TOTPDBConstants.tableName,
      where:
          '${TOTPDBConstants.domainColumn} LIKE ? OR ${TOTPDBConstants.usernameColumn} LIKE ?',
      whereArgs: ['%$searchTerm%', '%$searchTerm%'],
      limit: 1,
      offset: pos,
    );
  }

  getElementAtId(int id) async {
    return await db!.query(
      TOTPDBConstants.tableName,
      where: '${TOTPDBConstants.idColumn} = ?',
      whereArgs: [id],
    );
  }

  Future<int?> getCount() async {
    return Sqflite.firstIntValue(
      await db!.rawQuery('SELECT COUNT(*) FROM ${TOTPDBConstants.tableName}'),
    );
  }

  clear() async {
    await db?.delete(TOTPDBConstants.tableName);
  }
}
