import 'package:cipher_guardian/passwords/database_helper.dart';
import 'package:cipher_guardian/totp/database_helper.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Reset Passwords'),
          onTap: () {
            resetDatabaseDialog(
              context,
              'Passwords',
              PasswordDBHelper(),
              () {},
            );
          },
        ),
        ListTile(
          title: const Text('Reset TOTP'),
          onTap: () {
            resetDatabaseDialog(context, 'TOTP', TOTPDBHelper(), () {});
          },
        ),
      ],
    );
  }

  void resetDatabaseDialog(
    BuildContext context,
    String title,
    dynamic dbHelper,
    VoidCallback onSuccess,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.warning, color: Colors.red),
          title: Text('Reset $title Database'),
          content: Text(
            'Are you sure you want to reset the $title database? This will delete all your $title data. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await dbHelper.init();
                await dbHelper.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title database reset successfully')),
                );
                Navigator.of(context).pop();
                onSuccess();
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
