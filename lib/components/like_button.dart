import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final void Function()? onTap;
  final bool isLiked;
  const LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Icon(
        widget.isLiked ? Icons.favorite : Icons.favorite_border,
        color: widget.isLiked
            ? Colors.red
            : Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
