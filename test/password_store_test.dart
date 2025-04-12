import 'package:cipher_guardian/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cipher_guardian/passwords/generate.dart';
import 'package:cipher_guardian/passwords/store.dart';

void main() {
  runApp(MyApp());
  test('Password Generation', () async {
    PasswordStore store = PasswordStore();
    await store.init();
    await store.clear();
    await store.create(domain: 'xyz.com', username: 'asdfa', length: 40, passwordType: PasswordType.alphaNumeric, alphabetCase: AlphabetCase.mixed, includeSpecialChars: true, includeSpaces: false, strict: false);
    expect(await store.getCount(), 1);
  });
}
