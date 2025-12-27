import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final bool isSuccess;

  const MessageDisplay({super.key, required this.message, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        message,
        style: TextStyle(
          color: isSuccess ? Colors.green : Colors.red,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}