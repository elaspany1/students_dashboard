import 'dart:io';

import 'package:my_teacher/features/students/domain/enteties/student_entity.dart';

abstract class StudentsServices {
  Future<StudentEntity> addStudent(
      {required String name,
      required int lessonId,
      required String tableName,
      required String parentPhone,
      File? image,
      required bool feesPaid});

  Future<void> deleteStudent(
      {required int studentId, required String tableName, String image});

  Future<void> updateStudent(
      {required int studentId,
      required bool feesPayed,
      required String parentPhone,
      required String tableName});

  Future<List<StudentEntity>> getStudentsWithPagination({
    required String tableName,
    required int lessonId,
    String? searchName, // البحث
    required int page, // رقم الصفحة
    required int limit,
  });
}
