import 'package:flutter/material.dart';
import 'pages/totp_page.dart';
import 'pages/settings_page.dart';
import 'pages/password_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
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
    _pages = [PasswordPage(), TOTPpage(), SettingsPage()];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            _onItemTapped(index);
          },
          selectedIndex: _selectedIndex,
          destinations: const [
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
