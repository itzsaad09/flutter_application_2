import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../services/auth_service.dart';
import '../widgets/loading_button.dart';
import '../widgets/message_display.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _otp = '';
  String _message = '';
  bool _isSuccess = false;
  bool _isLoading = false;
  int _countdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _countdown > 0) {
        setState(() => _countdown--);
        _startTimer();
      } else if (mounted) {
        setState(() => _canResend = true);
      }
    });
  }

  void _verify() async {
    if (_otp.length != 6) {
      setState(() => _message = 'Please enter 6-digit code');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = await AuthService.verifyOtp(_otp);
      final token = data['token'];
      final email = await AuthService.getStoredEmail();

      if (token != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/change-password');
      }
    } catch (e) {
      setState(() {
        _message = e.toString().replaceFirst('Exception: ', '');
        _isSuccess = false;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resend() async {
    setState(() {
      _countdown = 60;
      _canResend = false;
      _isLoading = true;
    });
    _startTimer();

    try {
      await AuthService.resendOtp();
      setState(() {
        _message = 'New code sent!';
        _isSuccess = true;
      });
    } catch (e) {
      setState(() => _message = 'Failed to resend');
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
                  const Text('Verify Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('A 6-digit code has been sent to your email.'),
                  const SizedBox(height: 40),
                  PinCodeTextField(
                    length: 6,
                    onChanged: (v) => _otp = v,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    appContext: context,
                  ),
                  const SizedBox(height: 30),
                  MessageDisplay(message: _message, isSuccess: _isSuccess),
                  LoadingButton(text: 'Verify Account', isLoading: _isLoading, onPressed: _verify),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: _canResend ? _resend : null,
                    icon: const Icon(Icons.refresh),
                    label: Text(_canResend ? 'Resend Code' : 'Resend in ${_countdown}s'),
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