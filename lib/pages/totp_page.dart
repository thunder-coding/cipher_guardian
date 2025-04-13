import 'dart:async';

import 'package:cipher_guardian/totp/calculate_current_code.dart';
import 'package:cipher_guardian/totp/impl.dart';
import 'package:cipher_guardian/totp/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'totp_info.dart';

class TOTPpage extends StatefulWidget {
  const TOTPpage({super.key});

  @override
  State<TOTPpage> createState() => _TOTPpageState();
}

class _TOTPpageState extends State<TOTPpage> {
  TOTPStore store = TOTPStore();
  int _itemCount = 0;

  setInitItemCount() async {
    final val = await store.getCount();
    setState(() {
      _itemCount = val;
    });
  }

  @override
  initState() {
    super.initState();
    store.init().then((_) {
      setInitItemCount();
    });
    Timer.periodic(Duration(milliseconds: 100), (Timer _) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _itemCount,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: store.getElementAtPos(index, ""),
            builder: (context, snapshot) {
              final code =
                  snapshot.hasData
                      ? calculateCurrentCode(
                        secret: snapshot.data!.secret,
                        period: snapshot.data!.period,
                        counter: snapshot.data!.counter,
                        algorithm: snapshot.data!.algorithm,
                        type: snapshot.data!.type,
                        length: snapshot.data!.digits,
                      ).toString().padLeft(snapshot.data!.digits, '0')
                      : "000000";
              return Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: code));
                  },
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value:
                            snapshot.hasData
                                ? (1 -
                                    ((DateTime.now().millisecondsSinceEpoch ~/
                                                1000)
                                            .remainder(snapshot.data!.period) /
                                        snapshot.data!.period))
                                : 0,
                      ),
                      ListTile(
                        title: Text(
                          snapshot.hasData ? snapshot.data!.domain : "",
                        ),
                        subtitle: Text(
                          snapshot.hasData ? snapshot.data!.username : "",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (snapshot.hasData) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    icon: const Icon(
                                      Icons.warning,
                                      color: Colors.red,
                                    ),
                                    title: const Text('Delete Password'),
                                    content: const Text(
                                      'Are you sure you want to delete this password? This action cannot be undone.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          store.remove(snapshot.data!.id).then((
                                            _,
                                          ) {
                                            store.getCount().then((value) {
                                              setState(() {
                                                _itemCount = value;
                                              });
                                            });
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Text(
                        code,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => TotpInfo(
                    handler: ({
                      required String domain,
                      required String username,
                      required String secret,
                      required TOTPAlgorithm algorithm,
                      required TOTPType type,
                      required int digits,
                      required int period,
                      required int createdTimestamp,
                      required int counter,
                    }) {
                      store
                          .create(
                            domain: domain,
                            username: username,
                            secret: secret,
                            algorithm: algorithm,
                            type: type,
                            digits: digits,
                            period: period,
                            createdTimestamp: createdTimestamp,
                            counter: counter,
                          )
                          .then((_) {
                            store.getCount().then((value) {
                              setState(() {
                                _itemCount = value;
                              });
                            });
                          });
                    },
                  ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
