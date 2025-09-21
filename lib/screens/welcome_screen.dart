import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // After 3 seconds, navigate to the authentication check screen.
    Future.delayed(const Duration(seconds: 3), () {
      // This line is updated to go to the auth check route first.
      Navigator.of(context).pushReplacementNamed('/auth_check');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/axolotl.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Renbo',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF06292),
              ),
            ),
          ],
        ),
      ),
    );
  }
}