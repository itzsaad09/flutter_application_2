import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../widgets/password_field.dart';
import '../widgets/loading_button.dart';
import '../widgets/message_display.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _message = '';
  bool _isSuccess = false;
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final data = await AuthService.login(_email, _password);
      await Provider.of<AuthProvider>(context, listen: false)
          .loginSuccess(data['token'], _email);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      setState(() {
        _message = e.toString().replaceFirst('Exception: ', '');
        _isSuccess = false;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _googleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final data = await AuthService.googleSignIn();
      await Provider.of<AuthProvider>(context, listen: false)
          .loginSuccess(data['token'], data['user']['email']);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
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
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                      onChanged: (v) => _email = v.trim(),
                    ),
                    const SizedBox(height: 20),
                    PasswordField(onChanged: (v) => _password = v),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    MessageDisplay(message: _message, isSuccess: _isSuccess),
                    const SizedBox(height: 20),
                    LoadingButton(
                      text: 'Log In',
                      isLoading: _isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 20),
                    LoadingButton(
                      text: 'Sign in with Google',
                      isLoading: _isLoading,
                      onPressed: _googleSignIn,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      child: const Text("Don't have an account? Sign Up"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}