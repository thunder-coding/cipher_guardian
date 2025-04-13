import 'package:cipher_guardian/totp/impl.dart';
import 'package:cipher_guardian/totp/store.dart';
import 'package:flutter/material.dart';
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
              return FutureBuilder(
                future: store.getElementAtPos(index, ""),
                builder: (context, snapshot) {
                  return ListTile(
                    title: Text(snapshot.hasData ? snapshot.data!.domain : ""),
                    subtitle: Text(
                      snapshot.hasData ? snapshot.data!.username : "",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        if (snapshot.hasData) {
                          store.remove(snapshot.data!.id).then((_) {
                            store.getCount().then((value) {
                              setState(() {
                                _itemCount = value;
                              });
                            });
                          });
                        }
                      },
                    ),
                  );
                },
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
