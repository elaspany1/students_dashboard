import 'package:dartz/dartz.dart';
import 'package:my_teacher/core/errors/class_failure.dart';
import 'package:my_teacher/core/services/exams_service.dart';
import 'package:my_teacher/features/exams/presentation/domain/enteties/exam_entity.dart';

class ExamsRepo {
  final ExamsService service;

  ExamsRepo({required this.service});

  Future<Either<Failure, void>> addExam(
      {required String name, required int lessonId}) async {
    try {
      await service.addExam(name: name, tableName: 'exams', lessonId: lessonId);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteExam({required int examId}) async {
    try {
      await service.deleteExam(examId: examId, tableName: 'exams');
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateExam({
    required int examId,
    required String newName,
  }) async {
    try {
      await service.updateExam(
          examId: examId, newName: newName, tableName: 'exams');
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<ExamEntity>>> getAllExams(
      {required int lessonId}) async {
    try {
      final result =
          await service.getAllExams(tableName: 'exams', lessonId: lessonId);
      return right(result);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
