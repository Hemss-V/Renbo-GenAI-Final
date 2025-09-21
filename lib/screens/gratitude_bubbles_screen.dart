import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Make sure Lottie is imported
import 'package:renbo/models/gratitude.dart';
import 'package:renbo/services/gratitude_storage.dart';
import 'package:renbo/utils/theme.dart';
import 'package:renbo/widgets/gratitude_bubbles_widget.dart';

class GratitudeBubblesScreen extends StatefulWidget {
  const GratitudeBubblesScreen({super.key});

  @override
  State<GratitudeBubblesScreen> createState() => _GratitudeBubblesScreenState();
}

class _GratitudeBubblesScreenState extends State<GratitudeBubblesScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  List<Gratitude> _gratitudes = [];
  late final AnimationController _animationController;
  final Random _random = Random();
  bool _showConfetti = false; // New: State to control confetti visibility

  @override
  void initState() {
    super.initState();
    _loadGratitudes();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadGratitudes() {
    setState(() {
      _gratitudes = GratitudeStorage.gratitudes;
    });
  }

  void _addGratitude() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final gratitude = Gratitude(text: text, timestamp: DateTime.now());
      GratitudeStorage.addGratitude(gratitude);
      _controller.clear();
      _loadGratitudes();

      // New: Trigger confetti animation
      setState(() {
        _showConfetti = true;
      });
      // Hide confetti after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showConfetti = false;
          });
        }
      });
    }
  }

  void _showAddGratitudeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Add a Gratitude',
          style: TextStyle(color: AppTheme.darkGray),
        ),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'What are you grateful for today?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppTheme.mediumGray),
            ),
          ),
          onSubmitted: (_) {
            _addGratitude();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.mediumGray),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addGratitude();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Gratitude Bubbles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGratitudeDialog,
        backgroundColor: const Color.fromARGB(255, 129, 167, 199),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          if (_gratitudes.isEmpty)
            const Center(
              child: Text(
                'No gratitudes yet. Add one to see it float!',
                style: TextStyle(fontSize: 16, color: AppTheme.mediumGray),
                textAlign: TextAlign.center,
              ),
            ),
          ..._gratitudes.map((gratitude) {
            const double size = 60.0;
            // Use MediaQuery to get screen size for better random positioning
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;
            
            // Randomly position bubbles within a reasonable range
            final double xOffset = _random.nextDouble() * (screenWidth - size);
            final double yOffset = _random.nextDouble() * (screenHeight * 0.7 - size); // Exclude app bar and bottom

            return Positioned( // Use Positioned to place bubbles
              left: xOffset,
              top: yOffset,
              child: GratitudeBubble(
                gratitude: gratitude,
                bubbleSize: size,
                animation: _animationController,
                xOffset: xOffset, // Pass xOffset
                yOffset: yOffset, // Pass yOffset
                onUpdated: _loadGratitudes,
              ),
            );
          }).toList(),

          // New: Confetti animation, visible only when _showConfetti is true
          if (_showConfetti)
            Center( // Center the confetti animation
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                repeat: false, // Play once
                onLoaded: (composition) {
                  // Optional: You could use this to control animation speed or loop count
                },
              ),
            ),
        ],
      ),
    );
  }
}