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
    _pages = [
    HomePage(),
    PasswordPage(),
    TOTPpage(),
    SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.key),label: 'Password'),
            BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'TOTP'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          selectedItemColor: Colors.purpleAccent,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
} 