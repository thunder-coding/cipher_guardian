import 'package:cipher_guardian/passwords/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'password_info.dart';
import 'password_new_handler.dart';
import 'package:cipher_guardian/passwords/generate.dart';

class PasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const AccTiles();
  }
}

class AccTiles extends StatefulWidget {
  const AccTiles({super.key});

  @override
  _AccTilesState createState() => _AccTilesState();
}

class _AccTilesState extends State<AccTiles> {
  PasswordStore store = PasswordStore();
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
              return ListTile(
                title: Text(snapshot.hasData ? snapshot.data!.domain : ""),
                subtitle: Text(snapshot.hasData ? snapshot.data!.username : ""),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    if (snapshot.hasData) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            icon: const Icon(Icons.warning, color: Colors.red),
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
                                  store.remove(snapshot.data!.id).then((_) {
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
                onLongPress: () {
                  Clipboard.setData(
                    ClipboardData(text: snapshot.data!.password),
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
                  (context) => PasswordInfoWrapper(
                    handler: ({
                      required String domain,
                      required String username,
                      required String password,
                      required PasswordType passwordType,
                      required AlphabetCase alphabetCase,
                      required bool includeSpecialChars,
                      required bool includeSpaces,
                      required bool generatedPassword,
                      required bool strict,
                      required int length,
                    }) {
                      setState(() {
                        password_new_handler(
                          domain: domain,
                          username: username,
                          password: password,
                          passwordType: passwordType,
                          alphabetCase: alphabetCase,
                          includeSpecialChars: includeSpecialChars,
                          includeSpaces: includeSpaces,
                          generatedPassword: generatedPassword,
                          strict: strict,
                          length: length,
                        ).then((_) {
                          store.getCount().then((value) {
                            setState(() {
                              _itemCount = value;
                            });
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
