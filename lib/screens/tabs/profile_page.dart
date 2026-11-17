import 'package:flutter/material.dart';

import '../../services/demo_auth.dart';
import '../../widgets/info_tile.dart';
import '../../widgets/profile_header.dart';
import '../auth/login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _handleLogout(BuildContext context) {
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
        title: const Text('My Profile'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ProfileHeader(name: 'Jonathan Jr. H. Peguit'),
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
            onPressed: () => _handleLogout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
