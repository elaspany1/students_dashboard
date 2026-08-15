import 'package:my_teacher/features/lessons/presentation/domain/enteties/lesson_entity.dart';

abstract class LessonService {
  Future<void> addLesson(
      {required String name, required String tableName, required int classId});
  Future<void> deleteLesson({required int lessonId, required String tableName});
  Future<void> updateLesson(
      {required int lessonId,
      required String newName,
      required String tableName});
  Future<List<LessonEntity>> getAllLessons(
      {required String tableName, required int classId});
}
