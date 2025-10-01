import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  const InputField({super.key, required this.controller, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Type word here',
      ),
      onSubmitted: (_) => onSubmit(),
    );
  }
}
