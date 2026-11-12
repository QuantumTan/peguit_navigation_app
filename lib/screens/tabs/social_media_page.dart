import 'package:flutter/material.dart';

import '../../widgets/social_account_card.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  void showAccount(BuildContext context, String account) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Selected account: $account')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Media')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Connect With Me',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Tap an account to display its username.'),
          const SizedBox(height: 20),
          SocialAccountCard(
            icon: Icons.facebook,
            color: Colors.blue,
            name: 'Facebook',
            username: 'Tan Peguit',
            onTap: () => showAccount(
              context,
              'Facebook: https://www.facebook.com/tantanluxe',
            ),
          ),
          SocialAccountCard(
            icon: Icons.camera_alt,
            color: Colors.pink,
            name: 'Instagram',
            username: 'jnthnpgt',
            onTap: () => showAccount(
              context,
              'Instagram: https://www.instagram.com/jnthnpgt/',
            ),
          ),
          SocialAccountCard(
            icon: Icons.play_circle,
            color: Colors.red,
            name: 'YouTube',
            username: 'Sai',
            onTap: () => showAccount(
              context,
              'YouTube: https://www.youtube.com/@Saitosan.ruuuuu',
            ),
          ),
        ],
      ),
    );
  }
}
