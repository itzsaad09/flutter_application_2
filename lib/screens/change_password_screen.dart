import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/password_field.dart';
import '../widgets/loading_button.dart';
import '../widgets/message_display.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String _newPass = '', _confirm = '';
  String _message = '';
  bool _isSuccess = false;
  bool _isLoading = false;

  bool _isStrong(String pass) {
    return pass.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(pass) &&
        RegExp(r'[a-z]').hasMatch(pass) &&
        RegExp(r'[0-9]').hasMatch(pass) &&
        RegExp(r'[^A-Za-z0-9]').hasMatch(pass);
  }

  void _submit() async {
    if (_newPass != _confirm) {
      setState(() => _message = 'Passwords do not match');
      return;
    }
    if (!_isStrong(_newPass)) {
      setState(() => _message = 'Password must be 8+ chars with upper, lower, number & symbol');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.recoverPassword(_newPass, _confirm);
      setState(() {
        _message = 'Password changed successfully! Redirecting...';
        _isSuccess = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/signin');
      });
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
                  const Text('Change Password', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  PasswordField(onChanged: (v) => _newPass = v, hintText: 'New Password'),
                  const SizedBox(height: 20),
                  PasswordField(onChanged: (v) => _confirm = v, hintText: 'Confirm New Password'),
                  const SizedBox(height: 30),
                  MessageDisplay(message: _message, isSuccess: _isSuccess),
                  LoadingButton(text: 'Change Password', isLoading: _isLoading, onPressed: _submit),
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