import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/password_field.dart';
import '../widgets/loading_button.dart';
import '../widgets/message_display.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fname = '', _lname = '', _contact = '', _email = '', _pass = '', _confirm = '';
  String _message = '';
  bool _isSuccess = false;
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pass != _confirm) {
      setState(() => _message = 'Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.saveUser('', _email); // Store email for OTP
      final data = await AuthService.register({
        'fname': _fname,
        'lname': _lname,
        'contactno': _contact,
        'email': _email,
        'password': _pass,
        'confirmPassword': _confirm,
      });

      setState(() {
        _message = 'Registration successful! Redirecting to OTP...';
        _isSuccess = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/verify');
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
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Register', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'First Name', prefixIcon: Icon(Icons.person)),
                            onChanged: (v) => _fname = v.trim(),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'Last Name', prefixIcon: Icon(Icons.person)),
                            onChanged: (v) => _lname = v.trim(),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Contact No',
                        prefixIcon: Icon(Icons.phone),
                        hintText: '+92 xxx xxxxxxx',
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (v) {
                        if (!v.startsWith('+92')) v = '+92 ';
                        _contact = v;
                      },
                      initialValue: '+92 ',
                      validator: (v) => v!.length < 13 ? 'Invalid phone' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => _email = v.trim(),
                      validator: (v) => v!.contains('@') ? null : 'Invalid email',
                    ),
                    const SizedBox(height: 20),
                    PasswordField(onChanged: (v) => _pass = v, hintText: 'Password'),
                    const SizedBox(height: 20),
                    PasswordField(onChanged: (v) => _confirm = v, hintText: 'Confirm Password'),
                    const SizedBox(height: 20),
                    MessageDisplay(message: _message, isSuccess: _isSuccess),
                    LoadingButton(text: 'Register', isLoading: _isLoading, onPressed: _submit),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/signin'),
                      child: const Text('Already have an account? Login'),
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