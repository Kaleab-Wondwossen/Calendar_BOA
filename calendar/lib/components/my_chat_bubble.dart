import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String messages;
  final Color bubbleColor;

  const ChatBubble({
    super.key,
    required this.messages,
    required this.bubbleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: bubbleColor,
      ),
      child: Text(
        messages,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
