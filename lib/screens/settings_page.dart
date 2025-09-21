import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:renbo/screens/auth_page.dart';
import 'package:renbo/utils/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? 'No Name';
    final String email = user?.email ?? 'No Email';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: AppTheme.darkGray, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(icon: Icons.person, label: 'Name', value: displayName),
            _buildDetailRow(icon: Icons.email, label: 'Email', value: email),
            const Spacer(), // Pushes the logout button to the bottom
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // Redirect to the login page after signing out
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AuthPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Log Out', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.darkGray),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: AppTheme.darkGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
