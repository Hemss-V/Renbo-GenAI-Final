import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

import 'package:renbo/api/gemini_service.dart';
import 'package:renbo/utils/theme.dart';
import 'package:renbo/screens/chat_screen.dart';
import 'package:renbo/screens/meditation_screen.dart';
import 'package:renbo/screens/hotlines_screen.dart';
import 'package:renbo/widgets/mood_card.dart';
import 'package:renbo/screens/stress_tap_game.dart';
import 'package:renbo/screens/settings_page.dart';
import 'package:renbo/screens/gratitude_bubbles_screen.dart';
import 'package:renbo/screens/calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = "User";
  String _thoughtOfTheDay = "Loading a new thought...";
  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _fetchThoughtOfTheDay();
    _loadUserData();
  }

  void _loadUserData() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted && user != null) {
        setState(() {
          _userName = user.displayName ?? "User";
        });
      }
    });
  }

  void _fetchThoughtOfTheDay() async {
    try {
      final thought = await _geminiService.generateThoughtOfTheDay();
      if (mounted) {
        setState(() {
          _thoughtOfTheDay = thought;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _thoughtOfTheDay =
              "The best way to predict the future is to create it.";
        });
      }
      debugPrint('Error fetching thought of the day: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $_userName!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              const SizedBox(height: 16),
              MoodCard(
                title: 'Thought of the day',
                content: _thoughtOfTheDay,
                image: 'assets/lottie/axolotl.json',
              ),
              const SizedBox(height: 16),
              _buildMainButtons(context),
              const SizedBox(height: 24),
              
              // ✅ Lottie animation is now wrapped in a Center widget
              Center(
                child: SizedBox(
                  height: 180,
                  child: Lottie.asset('assets/lottie/help.json'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildButton(
              context,
              icon: Icons.edit_note,
              label: 'Journal',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              ),
            ),
            const SizedBox(width: 16),
            _buildButton(
              context,
              icon: Icons.chat_bubble_outline,
              label: 'Chat with Ren',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              ),
            ),
            const SizedBox(width: 16),
            _buildButton(
              context,
              icon: Icons.headphones_outlined,
              label: 'Meditation',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MeditationScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildButton(
              context,
              icon: Icons.phone_in_talk,
              label: 'Hotlines',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HotlinesScreen()),
              ),
            ),
            const SizedBox(width: 16),
            _buildButton(
              context,
              icon: Icons.videogame_asset_outlined,
              label: 'Game',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RelaxGame()),
              ),
            ),
            const SizedBox(width: 16),
            _buildButton(
              context,
              icon: Icons.bubble_chart,
              label: 'Gratitude',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const GratitudeBubblesScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: AppTheme.primaryColor),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}