import 'package:flutter/material.dart';
import 'package:renbo/utils/theme.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;

  const ChatBubble({super.key, required this.text, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: isSender
              ? AppTheme.primaryColor.withOpacity(0.8)
              : AppTheme.lightGray,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isSender
                ? const Radius.circular(20)
                : const Radius.circular(0),
            bottomRight: isSender
                ? const Radius.circular(0)
                : const Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSender ? Colors.white : AppTheme.darkGray,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
