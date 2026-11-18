import 'package:flutter/material.dart';

import 'demo_auth.dart';
import 'main_screen.dart';
import 'register_screen.dart';
import 'widgets/app_text_field.dart';
import 'widgets/auth_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;

  void login() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final isValid = DemoAuth.login(
      usernameController.text.trim(),
      passwordController.text,
    );

    if (isValid) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(icon: Icons.lock_person, title: 'Welcome Back!'),
              const SizedBox(height: 24),
              AppTextField(
                controller: usernameController,
                label: 'Username',
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your username.'
                    : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: passwordController,
                label: 'Password',
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  tooltip: hidePassword ? 'Show password' : 'Hide password',
                  icon: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your password.'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: login, child: const Text('Login')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
