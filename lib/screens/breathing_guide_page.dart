import 'package:flutter/material.dart';
import 'dart:async';
import 'package:renbo/utils/theme.dart';

class BreathingGuidePage extends StatefulWidget {
  const BreathingGuidePage({super.key});

  @override
  _BreathingGuidePageState createState() => _BreathingGuidePageState();
}

class _BreathingGuidePageState extends State<BreathingGuidePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Timer _breathingTimer;
  int _countdown = 4;
  String _instruction = "Breathe in";
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  void _startBreathing() {
    setState(() {
      _isAnimating = true;
      _instruction = "Breathe in";
      _countdown = 4;
    });
    
    // Start the expansion animation
    _animationController.forward(from: 0.0);

    _breathingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        if (_countdown < 0) {
          if (_instruction == "Breathe in") {
            _instruction = "Hold";
            _countdown = 2;
            _animationController.stop(); // Hold the animation
          } else if (_instruction == "Hold") {
            _instruction = "Breathe out";
            _countdown = 6;
            _animationController.duration = const Duration(seconds: 6);
            _animationController.reverse(from: 1.0); // Start contraction
          } else if (_instruction == "Breathe out") {
            _instruction = "Breathe in";
            _countdown = 4;
            _animationController.duration = const Duration(seconds: 4);
            _animationController.forward(from: 0.0); // Start expansion
          }
        }
      });
    });
  }

  void _pauseBreathing() {
    _breathingTimer.cancel();
    _animationController.stop();
    setState(() {
      _isAnimating = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (_isAnimating) {
      _breathingTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breathing Guide"),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.darkGray,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _instruction,
              style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 100),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                double scale = 1.0;
                if (_instruction == "Breathe in") {
                  scale = 1.0 + _animationController.value;
                } else if (_instruction == "Breathe out") {
                  scale = 2.0 - _animationController.value;
                } else {
                  scale = 2.0; // Hold at the expanded size
                }
                
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _countdown > 0 ? '$_countdown' : '',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: _isAnimating ? _pauseBreathing : _startBreathing,
              child: Text(_isAnimating ? 'Pause' : 'Start Breathing'),
            ),
          ],
        ),
      ),
    );
  }
}
