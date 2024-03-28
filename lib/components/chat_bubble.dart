import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Color? color;
  final String text;
  const ChatBubble({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(text),
    );
  }
}
