import 'dart:io';

import 'package:my_teacher/features/questions/domain/enteties/question_entity.dart';

abstract class QuestionServices {
  Future<void> addQuestion(
      {required String question,
      required List<String> options,
      required int lessonId,
      required String correctAnswer,
      File? image});
  Future<void> deleteQuestion({required int questionId, String image});
  Future<void> updateQuestion(
      {required int questionId,
      required String newQuestion,
      required String correctAnswer,
      String? image,
      File? file,
      required List<String> options});
  Future<List<QuestionEntity>> getAllQuestions({required int lessonId});
}
