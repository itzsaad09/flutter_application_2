import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'app.dart';
import 'providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Google Sign-In (required in v7+)
  await GoogleSignIn.instance.initialize(
    // Optional: Add your platform-specific client IDs here if needed
    // clientId: 'your-android-or-ios-client-id', // From Google Cloud Console
    serverClientId: dotenv.env['GOOGLE_CLIENT_ID']!,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}