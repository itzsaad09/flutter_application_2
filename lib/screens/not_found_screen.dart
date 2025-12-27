import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('4😢4', style: TextStyle(fontSize: 100, color: Colors.grey[800])),
            const Text('Page not found', style: TextStyle(fontSize: 28)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}