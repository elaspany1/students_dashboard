import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/features/students/domain/enteties/student_entity.dart';
import 'package:my_teacher/features/students/domain/repos/students_repo.dart';

part 'student_state.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final StudentRepo studentsRepo;

  int _page = 0;
  bool _hasMore = true;
  bool _isLoading = false;
  String _lastSearchQuery = '';
  // ignore: unused_field
  int _lastLessonId = 0;

  List<StudentEntity> _students = [];

  StudentsCubit({required this.studentsRepo}) : super(StudentsInitial());

  void reset() {
    _page = 0;
    _hasMore = true;
    _students = [];
    _lastSearchQuery = '';
    _lastLessonId = 0;
  }

  Future<void> getAllStudents({
    required int lessonId,
    String? searchQuery,
    bool reset = false,
    int limit = 10,
  }) async {
    if (_isLoading) return;
    if (!_hasMore && !reset) return;

    _isLoading = true;

    if (reset) {
      _page = 0;
      _hasMore = true;
      _students = [];
      _lastSearchQuery = searchQuery?.trim() ?? '';
      _lastLessonId = lessonId;
    }

    emit(StudentsLoading(List.from(_students)));

    final result = await studentsRepo.getAllStudents(
      searchQuery: _lastSearchQuery.isEmpty ? null : _lastSearchQuery,
      page: _page,
      limit: limit,
    );

    result.fold((failure) {
      _isLoading = false;
      emit(StudentsFailure(failure.message, List.from(_students)));
    }, (newStudents) {
      if (newStudents.length < limit) _hasMore = false;
      _students.addAll(newStudents);
      _page++;
      _isLoading = false;
      emit(StudentsSuccess(List.from(_students)));
    });
  }

  void resetSearch() {
    _lastSearchQuery = '';
    _page = 0;
    _hasMore = true;
    _students = [];
  }

  Future<void> addStudent({
    required String name,
    required int lessonId,
    required String parentPhone,
    required bool feesPaid,
    File? image,
  }) async {
    emit(StudentsLoading(List.from(_students)));

    final result = await studentsRepo.addStudent(
      name: name,
      lessonId: lessonId,
      parentPhone: parentPhone,
      feesPaid: feesPaid,
      image: image,
    );

    result.fold(
      (err) => emit(StudentsFailure(err.toString(), List.from(_students))),
      (student) {
        _students.insert(0, student); // يظهر فوق مباشرة بالقائمة
        emit(AddStudentSuccess(
            List.from(_students), student)); // 👈 مهم للـ BlocListener
      },
    );
  }

  Future<void> updateStudent({
    required int studentId,
    required String parentPhone,
    required bool feesPayed,
    required int lessonId,
  }) async {
    emit(StudentsLoading(List.from(_students)));
    final result = await studentsRepo.updateStudent(
      studentId: studentId,
      parentPhone: parentPhone,
      feesPayed: feesPayed,
    );

    result.fold(
      (failure) {
        emit(StudentsFailure(failure.toString(), List.from(_students)));
      },
      (student) {
        emit(UpdateStudentSuccess(List.from(_students)));
      },
    );
  }

  Future<void> deleteStudent({
    required int studentId,
    required String image,
  }) async {
    emit(StudentsLoading(List.from(_students)));
    final result = await studentsRepo.deleteStudent(
      studentId: studentId,
      image: image,
    );

    result.fold((failure) {
      emit(StudentsFailure(failure.toString(), List.from(_students)));
    }, (_) {
      _students.removeWhere((s) => s.id == studentId);
      emit(StudentsSuccess(List.from(_students)));
    });
  }
}
