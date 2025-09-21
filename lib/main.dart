import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'utils/theme.dart';
import 'providers/mood_provider.dart';
import 'models/journal_entry.dart';
import 'models/gratitude.dart';
import 'firebase_options.dart';
import 'screens/welcome_screen.dart'; // <-- Import WelcomeScreen
import 'screens/auth_page.dart';
import 'screens/home_screen.dart';
import 'services/journal_storage.dart';
import 'services/gratitude_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(GratitudeAdapter());
  await JournalStorage.init();
  await GratitudeStorage.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodProvider(),
      child: const MyApp(), // <-- Change to MyApp
    ),
  );
}

// This is now the root widget of your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renbo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // 1. Set the initial route to your WelcomeScreen
      initialRoute: '/welcome',
      // 2. Define all the app's routes
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/auth_check': (context) => const AuthCheck(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const AuthPage(),
      },
    );
  }
}

// This new widget contains the logic to check for a logged-in user.
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show a loading indicator while checking.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If the snapshot has data, the user is signed in.
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        // Otherwise, the user is not signed in.
        return const AuthPage();
      },
    );
  }
}