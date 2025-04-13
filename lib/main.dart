import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:local_auth/local_auth.dart';
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

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  AuthState _authState = AuthState.notAuthorized;

  late final AppLifecycleListener _appLifecycleListener;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late List<Widget> _pages;
  List<String> _pageNames = ['Passwords', 'TOTP', 'Settings'];

  @override
  void initState() {
    super.initState();
    _pages = [PasswordPage(), TOTPpage(), SettingsPage()];
    auth.isDeviceSupported().then((bool isSupported) {
      if (isSupported) {
        setState(() {
          _supportState = _SupportState.supported;
        });
      } else {
        setState(() {
          _supportState = _SupportState.unsupported;
        });
      }
    });
    _appLifecycleListener = AppLifecycleListener(
      onStateChange: (AppLifecycleState state) {
        if (state == AppLifecycleState.hidden) {
          if (_authState == AuthState.authorized) {
            setState(() {
              _authState = AuthState.notAuthorized;
            });
          }
        }
        if (state == AppLifecycleState.resumed) {
          if (_authState == AuthState.notAuthorized) {
            setState(() {
              _authState = AuthState.authorizing;
            });
          }
        }
      },
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        setState(() {
          _authState = AuthState.authorized;
        });
      } else {
        setState(() {
          _authState = AuthState.notAuthorized;
        });
      }
    } catch (e) {
      setState(() {
        _authState = AuthState.notAuthorized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: () {
        if (_supportState == _SupportState.unknown) {
          return const Center(child: CircularProgressIndicator());
        } else if (_supportState == _SupportState.unsupported) {
          return const Center(
            child: Text('Biometric authentication is not supported'),
          );
        } else if (_authState == AuthState.notAuthorized) {
          _authenticate();
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please authenticate to access the app',
                    style: TextStyle(fontSize: 20),
                  ),
                  FilledButton(
                    onPressed: _authenticate,
                    child: const Text('Authenticate'),
                  ),
                ],
              ),
            ),
          );
        } else if (_authState == AuthState.authorizing) {
          return const Center(child: CircularProgressIndicator());
        } else if (_authState == AuthState.authorized) {
          return Scaffold(
            appBar: AppBar(title: Text(_pageNames[_selectedIndex])),
            body: _pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                _onItemTapped(index);
              },
              selectedIndex: _selectedIndex,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.key), label: 'Password'),
                NavigationDestination(
                  icon: Icon(Icons.access_time),
                  label: 'TOTP',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        }
      }(),
    );
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    super.dispose();
  }
}

enum AuthState { authorized, notAuthorized, authorizing }

enum _SupportState { unknown, supported, unsupported }
