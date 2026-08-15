part of 'question_cubit.dart';

abstract class QuestionsState {}

class QuestionsInitial extends QuestionsState {}

class QuestionsLoading extends QuestionsState {}

class QuestionsSuccess extends QuestionsState {
  final List<QuestionEntity> questions;

  QuestionsSuccess({required this.questions});
}

class QuestionsFailure extends QuestionsState {
  final String message;

  QuestionsFailure(this.message);
}

class AddQuestionsSuccess extends QuestionsState {}

class UpdateQuestionsSuccess extends QuestionsState {}
