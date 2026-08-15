import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_teacher/core/errors/class_failure.dart';
import 'package:my_teacher/core/services/question_services.dart';
import 'package:my_teacher/features/questions/domain/enteties/question_entity.dart';

class QuestionRepo {
  final QuestionServices questionServices;

  QuestionRepo({required this.questionServices});

  Future<Either<Failure, void>> addQuestion({
    required String question,
    required List<String> options,
    required int lessonId,
    required String correctAnswer,
    File? image,
  }) async {
    try {
      await questionServices.addQuestion(
        question: question,
        options: options,
        lessonId: lessonId,
        correctAnswer: correctAnswer,
        image: image,
      );
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<QuestionEntity>>> getAllQuestions({
    required int lessonId,
  }) async {
    try {
      final result = await questionServices.getAllQuestions(
        lessonId: lessonId,
      );
      return right(result);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteQuestion({
    required int questionId,
    required String image,
  }) async {
    try {
      await questionServices.deleteQuestion(
        questionId: questionId,
        image: image,
      );
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateQuestion({
    required int questionId,
    required String newQuestion,
    required String correctAnswer,
    String? image,
    File? file,
    required List<String> options,
  }) async {
    try {
      await questionServices.updateQuestion(
        file: file,
        image: image,
        questionId: questionId,
        newQuestion: newQuestion,
        correctAnswer: correctAnswer,
        options: options,
      );
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
