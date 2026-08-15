part of 'answers_cubit.dart';

abstract class AnswersState {
  final List<AnswersEntity> answers;
  const AnswersState(this.answers);
}

class AnswersInitial extends AnswersState {
  const AnswersInitial() : super(const []);
}

class AnswersLoading extends AnswersState {
  const AnswersLoading(super.students);
}

class AnswersSuccess extends AnswersState {
  const AnswersSuccess(super.students);
}

class AnswersFailure extends AnswersState {
  final String message;
  const AnswersFailure(this.message, List<AnswersEntity> answers)
      : super(answers);
}
