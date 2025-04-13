import 'package:cipher_guardian/totp/impl.dart';

import 'database_helper.dart';

class Entry {
  final int id;
  final String domain;
  final String username;
  final String secret;
  final TOTPAlgorithm algorithm;
  final String type; // TOTP or HOTP
  final int digits;
  final int period;
  final int createdTimestamp;
  final int counter;
  Entry({
    required this.id,
    required this.domain,
    required this.username,
    required this.secret,
    required this.algorithm,
    required this.type,
    required this.digits,
    required this.period,
    required this.createdTimestamp,
    required this.counter,
  });
}

class TOTPStore {
  static final TOTPDBHelper dbHelper = TOTPDBHelper();

  init() async {
    await dbHelper.init();
  }

  create({
    required String domain,
    required String username,
    required String secret,
    required TOTPAlgorithm algorithm,
    required String type,
    required int digits,
    required int period,
    required int createdTimestamp,
    required int counter,
  }) async {
    await dbHelper.insertTOTP(
      domain: domain,
      username: username,
      secret: secret,
      algorithm: algorithm.name,
      type: type,
      digits: digits,
      period: period,
      createdTimestamp: createdTimestamp,
      counter: counter,
    );
  }

  remove(int id) async {
    await dbHelper.deleteTOTP(id);
  }

  incrementCounter(int id) async {
    await dbHelper.incrementTOTPCounter(id);
  }

  getElementAtPos(int pos, String searchTerm) async {
    final List<Map> q = await dbHelper.getElementAtPos(pos, searchTerm);
    Entry entry = Entry(
      id: q[0][TOTPDBConstants.idColumn],
      domain: q[0][TOTPDBConstants.domainColumn],
      username: q[0][TOTPDBConstants.usernameColumn],
      secret: q[0][TOTPDBConstants.secretColumn],
      algorithm: TOTPAlgorithm.values[q[0][TOTPDBConstants.algorithmColumn]],
      type: q[0][TOTPDBConstants.typeColumn],
      digits: q[0][TOTPDBConstants.digitsColumn],
      period: q[0][TOTPDBConstants.periodColumn],
      createdTimestamp: q[0][TOTPDBConstants.createdTimestampColumn],
      counter: q[0][TOTPDBConstants.counterColumn],
    );
    return entry;
  }

  getCount() async {
    return await dbHelper.getCount();
  }

  clear() async {
    await dbHelper.clear();
  }
}
