// app.dart
import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';

class RenboApp extends StatelessWidget {
  const RenboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renbo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
