import 'package:flutter/material.dart';

import '../../widgets/info_tile.dart';
import '../../widgets/profile_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          ProfileHeader(name: 'Jonathan Jr. H. Peguit'),
          SizedBox(height: 24),
          Card(
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
        ],
      ),
    );
  }
}
