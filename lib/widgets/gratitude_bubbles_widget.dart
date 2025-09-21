import 'dart:math';
import 'package:flutter/material.dart';
import 'package:renbo/models/gratitude.dart';
import 'package:renbo/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:renbo/services/gratitude_storage.dart';

class GratitudeBubble extends AnimatedWidget {
  final Gratitude gratitude;
  final double bubbleSize;
  final double xOffset;
  final double yOffset;
  final VoidCallback onUpdated; // callback to refresh list after edit/delete

  const GratitudeBubble({
    super.key,
    required this.gratitude,
    required this.bubbleSize,
    required this.xOffset,
    required this.yOffset,
    required Animation<double> animation,
    required this.onUpdated,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    final double value = Curves.easeInOut.transform(animation.value);

    final double animatedX = sin(value * pi * 2 + xOffset) * 50;
    final double animatedY = cos(value * pi * 2 + yOffset) * 50;

    return Positioned(
      left: 50 + animatedX + xOffset,
      top: 100 + animatedY + yOffset,
      child: GestureDetector(
        onTap: () {
          _showGratitudeDetailDialog(context, gratitude);
        },
        child: Opacity(
          opacity: 0.8,
          child: Container(
            width: bubbleSize,
            height: bubbleSize,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 53, 135, 212).withOpacity(0.5),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.darkGray.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGratitudeDetailDialog(BuildContext context, Gratitude gratitude) {
    final formattedDate =
        DateFormat('MMMM d, yyyy').format(gratitude.timestamp);
    final formattedTime = DateFormat('h:mm a').format(gratitude.timestamp);

    final TextEditingController editController =
        TextEditingController(text: gratitude.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Gratitude Entry',
            style: TextStyle(color: AppTheme.primaryColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gratitude.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Added on: $formattedDate at $formattedTime',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.mediumGray,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditDialog(context, editController);
            },
            child: const Text("Edit",
                style: TextStyle(color: AppTheme.primaryColor)),
          ),
          TextButton(
            onPressed: () {
              gratitude.delete();
              Navigator.of(context).pop();
              onUpdated(); // refresh after delete
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Gratitude"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Update your gratitude...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              gratitude.text = controller.text.trim();
              gratitude.save(); // save changes to Hive
              Navigator.of(context).pop();
              onUpdated(); // refresh after edit
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
