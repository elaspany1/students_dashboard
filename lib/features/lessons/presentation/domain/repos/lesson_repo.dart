import 'package:dartz/dartz.dart';
import 'package:my_teacher/core/errors/class_failure.dart';
import 'package:my_teacher/core/services/lessons_services.dart';
import 'package:my_teacher/features/lessons/presentation/domain/enteties/lesson_entity.dart';

class LessonRepo {
  final LessonService service;

  LessonRepo({required this.service});

  Future<Either<Failure, void>> addLesson(
      {required String name,
      required String tableName,
      required int classId}) async {
    try {
      await service.addLesson(
          name: name, tableName: tableName, classId: classId);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteLesson(
      {required int lessonId, required String tableName}) async {
    try {
      await service.deleteLesson(lessonId: lessonId, tableName: tableName);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateLesson({
    required int lessonId,
    required String newName,
    required String tableName,
  }) async {
    try {
      await service.updateLesson(
          lessonId: lessonId, newName: newName, tableName: tableName);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<LessonEntity>>> getAllLessons(
      {required String tableName, required int classId}) async {
    try {
      final result =
          await service.getAllLessons(tableName: tableName, classId: classId);
      return right(result);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
