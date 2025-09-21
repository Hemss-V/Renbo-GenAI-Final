// lib/utils/constants.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'Renbo';
  static const String initialUsername = 'Sarina';
  static const String thoughtOfTheDay =
      "It's better to conquer yourself than to win a thousand battles.";

  // Use the dotenv package to access the API key
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
}
