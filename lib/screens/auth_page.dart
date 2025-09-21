import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/screens/home_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLogin = true;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (!isLogin)
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Your Name"),
              ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                UserCredential? userCredential;
                if (isLogin) {
                  userCredential = await _authService.login(
                    emailController.text,
                    passwordController.text,
                    context,
                  );
                } else {
                  // Pass the name from the new controller
                  userCredential = await _authService.signUp(
                    emailController.text,
                    passwordController.text,
                    context,
                    nameController.text,
                  );
                }
                if (userCredential != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                }
              },
              child: Text(isLogin ? "Login" : "Sign Up"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin
                  ? "Don't have an account? Sign Up"
                  : "Already have an account? Login"),
            )
          ],
        ),
      ),
    );
  }
}
