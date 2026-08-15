import 'package:flutter/material.dart';

class SectionDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final TextEditingController controller;
  final void Function(String value) onConfirm;
  final VoidCallback? onCancel;

  const SectionDialog({
    super.key,
    required this.title,
    required this.controller,
    required this.onConfirm,
    required this.confirmText,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'اسم القسم',
          prefixIcon: Icon(Icons.class_),
          border: OutlineInputBorder(),
        ),
        onSubmitted: onConfirm,
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () => onConfirm(controller.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
