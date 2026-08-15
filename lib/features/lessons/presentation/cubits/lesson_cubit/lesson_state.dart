part of 'lesson_cubit.dart';

abstract class LessonState {}

class LessonInitial extends LessonState {}

class LessonLoading extends LessonState {}

class LesssonSuccess extends LessonState with EquatableMixin {
  final List<LessonEntity> lessons;

  LesssonSuccess({required this.lessons});

  @override
  List<Object?> get props => [lessons];
}

class LessonFailure extends LessonState {
  final String message;

  LessonFailure(this.message);
}
