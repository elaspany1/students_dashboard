import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/features/questions/domain/enteties/question_entity.dart';
import 'package:my_teacher/features/questions/domain/repos/question_repo.dart';

part 'question_state.dart';

class QuestionsCubit extends Cubit<QuestionsState> {
  final QuestionRepo questionRepo;
  QuestionsCubit({required this.questionRepo}) : super(QuestionsInitial());

  Future<void> fetchQuestions({required int lessonId}) async {
    emit(QuestionsLoading());
    final result = await questionRepo.getAllQuestions(lessonId: lessonId);
    result.fold((l) {
      emit(QuestionsFailure(l.message));
    }, (questions) {
      emit(QuestionsSuccess(questions: questions));
    });
  }

  Future<void> addQuestions(
      {required String question,
      required int lessonId,
      required List<String> options,
      required String correctAnswer,
      File? image}) async {
    emit(QuestionsLoading());
    final result = await questionRepo.addQuestion(
        question: question,
        options: options,
        lessonId: lessonId,
        image: image,
        correctAnswer: correctAnswer);
    result.fold((err) {
      emit(QuestionsFailure(err.toString()));
    }, (_) {
      emit(AddQuestionsSuccess());
    });
  }

  Future<void> updateQuestions(
      {required int questionId,
      required String newQuestion,
      required List<String> options,
      required String correctAnswer,
      required int lessonId,
      String? image,
      File? file}) async {
    emit(QuestionsLoading());
    final result = await questionRepo.updateQuestion(
        questionId: questionId,
        newQuestion: newQuestion,
        correctAnswer: correctAnswer,
        options: options,
        file: file,
        image: image);
    result.fold((f) {
      emit(QuestionsFailure(f.toString()));
    }, (_) {
      emit(UpdateQuestionsSuccess());
    });
  }

  Future<void> deleteQuestions(
      {required int questionId,
      required String image,
      required int lessonId}) async {
    emit(QuestionsLoading());
    final result =
        await questionRepo.deleteQuestion(questionId: questionId, image: image);
    result.fold((f) {
      emit(QuestionsFailure(f.toString()));
    }, (_) {
      fetchQuestions(lessonId: lessonId);
    });
  }
}
