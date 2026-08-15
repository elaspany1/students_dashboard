part of 'exams_cubit.dart';

abstract class ExamsState {}

class ExamsInitial extends ExamsState {}

class ExamsLoading extends ExamsState {}

class ExamsSuccess extends ExamsState with EquatableMixin {
  final List<ExamEntity> exams;

  ExamsSuccess({required this.exams});

  @override
  List<Object?> get props => [exams];
}

class ExamsFailure extends ExamsState {
  final String message;

  ExamsFailure(this.message);
}
