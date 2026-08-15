import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/features/lessons/presentation/domain/enteties/lesson_entity.dart';
import 'package:my_teacher/features/lessons/presentation/domain/repos/lesson_repo.dart';

part 'lesson_state.dart';

class LessonCubit extends Cubit<LessonState> {
  final LessonRepo service;
  LessonCubit({required this.service}) : super(LessonInitial());

  Future<void> fetchLessons({required int classId}) async {
    emit(LessonLoading());
    final result =
        await service.getAllLessons(tableName: 'lessons', classId: classId);
    result.fold(
      (l) => emit(LessonFailure(l.message)),
      (r) {
        emit(LesssonSuccess(lessons: r));
      },
    );
  }

  Future<void> addLesson({required String name, required int classId}) async {
    final result = await service.addLesson(
        name: name, tableName: 'lessons', classId: classId);
    result.fold(
      (l) => emit(LessonFailure(l.message)),
      (_) => fetchLessons(classId: classId),
    );
  }

  Future<void> updateLesson({required int id, required String newName}) async {
    final result = await service.updateLesson(
        lessonId: id, newName: newName, tableName: 'lessons');
    result.fold(
      (l) => emit(LessonFailure(l.message)),
      (_) => fetchLessons(classId: SelectedIdController.classId!),
    );
  }

  Future<void> deleteLesson({required int id}) async {
    final result =
        await service.deleteLesson(lessonId: id, tableName: 'lessons');
    result.fold(
      (l) => emit(LessonFailure(l.message)),
      (_) => fetchLessons(classId: SelectedIdController.classId!),
    );
  }
}
