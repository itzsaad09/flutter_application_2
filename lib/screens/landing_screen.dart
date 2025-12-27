import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Our App', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Your journey begins here.'),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/signin'),
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}