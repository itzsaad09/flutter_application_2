import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _name = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchName();
  }

  void _fetchName() async {
    try {
      final data = await AuthService.getUserData();
      if (data['isVerified'] == true) {
        setState(() => _name = '${data['fname']} ${data['lname']}');
      } else {
        Navigator.pushReplacementNamed(context, '/verify');
      }
    } catch (e) {
      setState(() => _name = 'User');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Welcome,', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                Text(_name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                const Text('You are successfully logged in!'),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}