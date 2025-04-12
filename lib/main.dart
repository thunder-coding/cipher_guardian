import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class PasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class TOTPpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), PasswordPage(), TOTPpage(), SettingsPage()];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: _pages[_selectedIndex],
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text("Add", style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.add, color: Colors.white),
          backgroundColor:
              ColorScheme.fromSeed(seedColor: Colors.purpleAccent).primary,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            _onItemTapped(index);
          },
          selectedIndex: _selectedIndex,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.key), label: 'Password'),
            NavigationDestination(icon: Icon(Icons.access_time), label: 'TOTP'),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
