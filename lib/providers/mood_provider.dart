import 'package:flutter/material.dart';

class MoodProvider with ChangeNotifier {
  String _currentMood = 'Good';

  String get currentMood => _currentMood;

  void setMood(String mood) {
    _currentMood = mood;
    notifyListeners();
  }
}
