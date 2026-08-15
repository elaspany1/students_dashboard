import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/errors/class_failure.dart';
import 'package:my_teacher/core/services/students_services.dart';
import 'package:my_teacher/features/students/domain/enteties/student_entity.dart';

class StudentRepo {
  final StudentsServices studentsServices;

  StudentRepo({required this.studentsServices});
  Future<Either<Failure, StudentEntity>> addStudent({
    required String name,
    required int lessonId,
    required String parentPhone,
    required bool feesPaid,
    File? image,
  }) async {
    try {
      var result = await studentsServices.addStudent(
          name: name,
          lessonId: lessonId,
          tableName: 'students',
          parentPhone: parentPhone,
          feesPaid: feesPaid,
          image: image);
      return right(result);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<StudentEntity>>> getAllStudents({
    String? searchQuery,
    required int page,
    required int limit,
  }) async {
    try {
      final result = await studentsServices.getStudentsWithPagination(
        tableName: 'students',
        lessonId: SelectedIdController.lessonId!,
        searchName: searchQuery?.trim(),
        page: page,
        limit: limit,
      );
      return right(result);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteStudent(
      {required int studentId, String? image}) async {
    try {
      var result = await studentsServices.deleteStudent(
          studentId: studentId, tableName: 'students', image: image!);
      return right(result);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateStudent({
    required int studentId,
    required String parentPhone,
    required bool feesPayed,
  }) async {
    try {
      final result = await studentsServices.updateStudent(
          studentId: studentId,
          feesPayed: feesPayed,
          parentPhone: parentPhone,
          tableName: 'students');
      return right(result);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
