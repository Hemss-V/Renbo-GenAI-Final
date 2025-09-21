import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const Gameu());
}

class Gameu extends StatelessWidget {
  const Gameu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gameu',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const RelaxGame(),
    );
  }
}

class RelaxGame extends StatefulWidget {
  const RelaxGame({super.key});

  @override
  State<RelaxGame> createState() => _RelaxGameState();
}

class _RelaxGameState extends State<RelaxGame> {
  double posX = 100;
  double posY = 100;
  final Random _random = Random();

  void _moveBall() {
    setState(() {
      posX = _random.nextDouble() * (MediaQuery.of(context).size.width - 80);
      posY = _random.nextDouble() * (MediaQuery.of(context).size.height - 80);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Tap the ball to move it.',
                  style: TextStyle(fontSize: 24, color: Colors.black54),
                ),
                SizedBox(height: 20),
                Text(
                  'Just relax and enjoy.',
                  style: TextStyle(fontSize: 18, color: Colors.black45),
                ),
              ],
            ),
          ),
          Positioned(
            top: posY,
            left: posX,
            child: GestureDetector(
              onTap: _moveBall,
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
