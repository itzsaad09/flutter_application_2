import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _email;
  String? _name;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get email => _email;
  String? get name => _name;

  AuthProvider() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final data = await AuthService.getStoredUser();
    if (data['token'] != null && data['email'] != null) {
      _isAuthenticated = true;
      _email = data['email'];
      // Optionally fetch name here
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginSuccess(String token, String email) async {
    await AuthService.saveUser(token, email);
    _isAuthenticated = true;
    _email = email;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await AuthService.logout();
    _isAuthenticated = false;
    _email = null;
    notifyListeners();
    Navigator.pushReplacementNamed(context, '/signin');
  }
}