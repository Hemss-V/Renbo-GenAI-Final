import 'package:flutter/material.dart';
import 'journal_screen.dart';
import 'journal_entries.dart';

class EmotionTrackerScreen extends StatelessWidget {
  const EmotionTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F2), // soft background
      appBar: AppBar(
        backgroundColor: const Color(0xFF568F87),
        title: const Text("How are you feeling?",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildEmotionButton(context, "😊 Happy", "That's wonderful!"),
                _buildEmotionButton(
                    context, "😢 Sad", "I’m sorry you’re feeling this way."),
                _buildEmotionButton(
                    context, "😡 Angry", "It’s okay to feel upset."),
                _buildEmotionButton(
                    context, "😴 Tired", "Rest is important, take it easy."),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionButton(
      BuildContext context, String label, String message) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF5BABB),
        foregroundColor: const Color(0xFF064232),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 3,
      ),
      onPressed: () {
        // First show message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFF568F87),
          ),
        );

        // Then show journaling button
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Would you like to journal these emotions?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalEntriesPage(),
                    ),
                  );
                },
                child: const Text("No"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF568F87),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JournalScreen(selectedDate: DateTime.now(), emotion: label), // pass emotion here
                    ),
                  );
                },
                child: const Text("Yes, Journal"),
              ),
            ],
          ),
        );
      },
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}
