import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:renbo/utils/theme.dart';

class MoodCard extends StatelessWidget {
  final String title;
  final String content;
  final String image;

  const MoodCard({
    super.key,
    required this.title,
    required this.content,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Lottie.asset(image, width: 80, height: 80),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(color: AppTheme.mediumGray),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
