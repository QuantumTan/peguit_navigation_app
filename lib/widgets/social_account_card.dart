import 'package:flutter/material.dart';

class SocialAccountCard extends StatelessWidget {
  const SocialAccountCard({
    super.key,
    required this.icon,
    required this.color,
    required this.name,
    required this.username,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String name;
  final String username;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(name),
        subtitle: Text(username),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
