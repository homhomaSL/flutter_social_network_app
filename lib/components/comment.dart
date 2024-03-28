import 'package:flutter/material.dart';

class MyComment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const MyComment({
    super.key,
    required this.text,
    required this.time,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(user), Text(time)],
          ),
          Text(text)
        ],
      ),
    );
  }
}
