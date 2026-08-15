import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/features/exams/presentation/domain/enteties/exam_entity.dart';
import 'package:my_teacher/features/exams/presentation/domain/repos/exams_repo.dart';

part 'exams_state.dart';

class ExamsCubit extends Cubit<ExamsState> {
  final ExamsRepo service;
  ExamsCubit({required this.service}) : super(ExamsInitial());

  int _reqToken = 0;
  int? _currentLessonId;
  // ignore: unused_field
  bool _isLoading = false;

  Future<void> fetchExams({required int lessonId}) async {
    _currentLessonId = lessonId;
    final myToken = ++_reqToken;

    // لو فيه داتا سابقة، متحوّلش لـ شاشة بيضا
    if (state is! ExamsSuccess) emit(ExamsLoading());

    _isLoading = true;
    final result = await service.getAllExams(lessonId: lessonId);
    if (myToken != _reqToken) return; // إسقاط النتيجة القديمة

    _isLoading = false;
    result.fold(
      (l) => emit(ExamsFailure(l.message)),
      (r) => emit(ExamsSuccess(exams: r)),
    );
  }

  Future<void> addExam({required String name, required int lessonId}) async {
    final res = await service.addExam(name: name, lessonId: lessonId);
    res.fold(
      (l) => emit(ExamsFailure(l.message)),
      (_) => fetchExams(lessonId: _currentLessonId ?? lessonId),
    );
  }

  Future<void> updateExam(
      {required int id, required String newName, required int lessonId}) async {
    final res = await service.updateExam(examId: id, newName: newName);
    res.fold(
      (l) => emit(ExamsFailure(l.message)),
      (_) => fetchExams(lessonId: _currentLessonId ?? lessonId),
    );
  }

  Future<void> deleteExam({required int id, required int lessonId}) async {
    final res = await service.deleteExam(examId: id);
    res.fold(
      (l) => emit(ExamsFailure(l.message)),
      (_) => fetchExams(lessonId: _currentLessonId ?? lessonId),
    );
  }
}
