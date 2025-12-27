import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final Function(String) onChanged;
  final String? hintText;

  const PasswordField({super.key, required this.onChanged, this.hintText});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.hintText ?? 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
      validator: (v) => v!.isEmpty ? 'Required' : null,
      onChanged: widget.onChanged,
    );
  }
}