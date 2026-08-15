import 'package:my_teacher/core/services/answers_services.dart';
import 'package:my_teacher/core/services/answers_storage_service.dart';
import 'package:my_teacher/features/answers/data/models/answers_model.dart';
import 'package:my_teacher/features/answers/domain/enteties/answers_entity.dart';
import 'package:my_teacher/features/students/data/models/student_model.dart';
import 'package:my_teacher/features/students/domain/enteties/student_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnswersServiseImpl implements AnswersServices {
  final AnswersStorageService answersStorageService;
  final supabase = Supabase.instance;
  AnswersServiseImpl({required this.answersStorageService});

  @override
  Future<void> clearAllAnswers() async {
    try {
      final storage = supabase.client.storage.from('students');

// نجيب كل الملفات اللي جوه answers/images
      final files = await storage.list(path: 'answers/images');

      final filePaths = files.map((f) => 'answers/images/${f.name}').toList();

      if (filePaths.isNotEmpty) {
        await storage.remove(filePaths);
      }

      // 4- حذف كل الصفوف من جدول answers
      await supabase.client.from('answers').delete().neq('id', 0);
    } catch (e) {
      throw Exception('فشل مسح الإجابات: $e');
    }
  }

  @override
  Future<List<AnswersEntity>> getAnswerssWithPagination({
    required String tableName,
    required int lessonId,
    String? searchName, // البحث
    required int page, // رقم الصفحة
    required int limit,
  }) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;

      var query =
          supabase.client.from(tableName).select().eq('lesson_id', lessonId);

      if (searchName != null && searchName.isNotEmpty) {
        query = query.ilike('name', '%${searchName.trim()}%');
      }

      final result = await query.range(start, end);

      return result.map((data) {
        final answer = AnswersModel.fromJson(data);

        if (answer.image != null) {
          final path = supabase.client.storage
              .from('students')
              .getPublicUrl('answers/images/${answer.image!}');
          answer.image = path;
        }

        return answer.answerEntityFromModel();
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch answers: $e');
    }
  }

  StudentEntity studentEntity({required List<Map<String, dynamic>> data}) {
    return StudentModel.fromJson(data.first).studentEntityFromModel();
  }
}
