import 'package:flutter/material.dart';

class MyTextBox extends StatefulWidget {
  final bool isVisible;
  final String text;
  final void Function()? onPressed;

  const MyTextBox({
    super.key,
    this.onPressed,
    required this.text,
    this.isVisible = true,
  });

  @override
  State<MyTextBox> createState() => _MyTextBoxState();
}

class _MyTextBoxState extends State<MyTextBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.isVisible
          ? const EdgeInsets.only(top: 0, right: 10, left: 10)
          : const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(widget.text.trim()),
                ],
              ),
              if (widget.isVisible)
                IconButton(
                    onPressed: widget.onPressed,
                    icon: const Icon(Icons.edit, size: 20))
            ],
          )
        ],
      ),
    );
  }
}
