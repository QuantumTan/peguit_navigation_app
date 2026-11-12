import 'package:flutter/material.dart';

import '../../widgets/info_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Icon(Icons.home, size: 80, color: Colors.indigo),
          SizedBox(height: 16),
          Text(
            'Welcome, Student!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Use the navigation bar below to explore the app.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                InfoTile(
                  icon: Icons.calculate,
                  title: 'Calculator',
                  subtitle: 'Perform basic arithmetic operations.',
                ),
                Divider(height: 1),
                InfoTile(
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'View student information.',
                ),
                Divider(height: 1),
                InfoTile(
                  icon: Icons.share,
                  title: 'Social Media',
                  subtitle: 'View social accounts.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
