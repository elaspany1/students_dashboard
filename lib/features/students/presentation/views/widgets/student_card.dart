import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final String studentCode;
  final String parentPhone;
  final String? imageUrl;
  final bool feesPayed;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentCard({
    super.key,
    required this.name,
    this.imageUrl,
    required this.onEdit,
    required this.onDelete,
    required this.studentCode,
    required this.parentPhone,
    required this.feesPayed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // صورة الطالب
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  imageUrl != null ? NetworkImage(imageUrl!) : null,
              child: imageUrl == null
                  ? const Icon(Icons.image_not_supported, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),

            // بيانات الطالب
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.person, "الاسم", name),
                  _buildInfoRow(Icons.phone, "رقم ولي الأمر", parentPhone),
                  _buildInfoRow(Icons.qr_code, "كود الطالب", studentCode),
                  _buildInfoRow(
                    Icons.attach_money,
                    "المصاريف",
                    feesPayed ? "✅ مدفوعة" : "❌ غير مدفوعة",
                    valueColor: feesPayed ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),

            // أزرار التعديل والحذف
            Column(
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'تعديل',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'حذف',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              "$label : $value",
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
