import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const MyTextField({
    super.key,
    this.hintText,
    this.obscureText = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        hintText: hintText,
      ),
    );
  }
}
