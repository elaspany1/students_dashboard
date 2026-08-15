import 'package:my_teacher/features/answers/domain/enteties/answers_entity.dart';

abstract class AnswersServices {
  Future<void> clearAllAnswers();

  Future<List<AnswersEntity>> getAnswerssWithPagination({
    required String tableName,
    required int lessonId,
    String? searchName, // البحث
    required int page, // رقم الصفحة
    required int limit,
  });
}
