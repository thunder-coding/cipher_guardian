import 'package:flutter/material.dart';

class PasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData(useMaterial3: true),
    debugShowCheckedModeBanner: false,
    home: const AccTiles());
  }
}

class AccTiles extends StatelessWidget {
  const AccTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: const <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("GitHub"),
              subtitle: Text("PassWord : **** ****"),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("Discord"),
              subtitle: Text("PassWord : **** ****"),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("Reddit"),
              subtitle: Text("PassWord : **** ****"),
              trailing: Icon(Icons.more_vert),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("Gmail"),
              subtitle: Text("PassWord : **** ****"),
              trailing: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }
}
