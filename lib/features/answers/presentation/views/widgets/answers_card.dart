import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final List<String> answers;
  const AnswerCard({
    super.key,
    required this.name,
    this.imageUrl,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                // صورة الطالب
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      imageUrl != null ? NetworkImage(imageUrl!) : null,
                  child: imageUrl == null
                      ? const Icon(Icons.image_not_supported,
                          color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 12),
                Text(name)
                // بيانات الطالب
                // أزرار التعديل والحذف
              ],
            ),
            Wrap(
              children: [
                ...List.generate(
                    answers.length,
                    (index) => Text(
                          '${answers[index]} - ',
                          style: TextStyle(fontSize: 10.sp),
                        ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
