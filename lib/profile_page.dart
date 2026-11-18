import 'package:flutter/material.dart';

import 'demo_auth.dart';
import 'login_screen.dart';
import 'widgets/info_tile.dart';
import 'widgets/profile_header.dart';

class ProfilePage extends StatelessWidget {
  final String username;

  const ProfilePage({
    super.key,
    required this.username,
  });

  void logout(BuildContext context) {
    DemoAuth.logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ProfileHeader(name: 'Jonathan Jr. H. Peguit'),
          const SizedBox(height: 8),
          Text(
            'Logged in as: $username',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Card(
            child: Column(
              children: [
                InfoTile(
                  icon: Icons.badge,
                  title: 'Student ID',
                  subtitle: '554826',
                ),
                InfoTile(
                  icon: Icons.school,
                  title: 'Course and Section',
                  subtitle: 'BSIT - 3447',
                ),
                InfoTile(
                  icon: Icons.email,
                  title: 'Email',
                  subtitle: 'j.peguit.554826@umindanao.edu.ph',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
