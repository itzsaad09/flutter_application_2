import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final Color? color;

  const LoadingButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SpinKitThreeBounce(color: Colors.white, size: 20)
            : Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}