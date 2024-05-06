import 'package:flutter/material.dart';

class SideMenuBar extends StatelessWidget {
  const SideMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:[

            ListTile(
              leading: const Icon(Icons.supervised_user_circle_sharp),
              title: const Text('Profile'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
    );
  }
}