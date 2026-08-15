import 'package:my_teacher/features/exams/presentation/domain/enteties/exam_entity.dart';

abstract class ExamsService {
  Future<void> addExam(
      {required String name, required String tableName, required int lessonId});
  Future<void> deleteExam({required int examId, required String tableName});
  Future<void> updateExam(
      {required int examId,
      required String newName,
      required String tableName});
  Future<List<ExamEntity>> getAllExams(
      {required String tableName, required int lessonId});
}
