import 'package:cipher_guardian/passwords/store.dart';
import 'package:flutter/material.dart';
import 'password_info.dart';

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

  @override
  initState() {
    super.initState();
    store.init().then((_) {
      setState(() {
        store.getCount().then((value) {
          _itemCount = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _itemCount,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Account $index'),
            subtitle: Text('Subtitle $index'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PasswordInfoWrapper(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
