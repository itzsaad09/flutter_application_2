import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/loading_button.dart';
import '../widgets/message_display.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String _message = '';
  bool _isSuccess = false;
  bool _isLoading = false;

  void _submit() async {
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      setState(() => _message = 'Please enter a valid email');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.saveUser('', email); // Store email for next steps
      // Note: Your current backend doesn't have /forgot endpoint. Assuming you added it.
      // If not, just redirect like web version:
      Navigator.pushReplacementNamed(context, '/verify');
    } catch (e) {
      setState(() {
        _message = e.toString().replaceFirst('Exception: ', '');
        _isSuccess = false;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Forgot Password', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('Enter your email to receive a password reset link.'),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  MessageDisplay(message: _message, isSuccess: _isSuccess),
                  LoadingButton(text: 'Get OTP', isLoading: _isLoading, onPressed: _submit),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/signin'),
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}