import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/not_found_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      routes: {
        '/landing': (_) => const LandingScreen(),
        '/signin': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/verify': (_) => const OtpVerificationScreen(),
        '/change-password': (_) => const ChangePasswordScreen(),
        '/dashboard': (_) => const DashboardScreen(),
      },
      onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const NotFoundScreen()),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (auth.isAuthenticated) {
          return const DashboardScreen();
        }
        return const LandingScreen();
      },
    );
  }
}