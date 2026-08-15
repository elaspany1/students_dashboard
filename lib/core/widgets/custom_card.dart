import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String sectionName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final void Function()? onTap;

  const CustomCard({
    super.key,
    required this.sectionName,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(
            sectionName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Wrap(
            spacing: 8,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
