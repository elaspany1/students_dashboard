import 'dart:io';

import 'package:my_teacher/core/services/student_storage_service.dart';
import 'package:my_teacher/core/services/students_services.dart';
import 'package:my_teacher/features/students/data/models/student_model.dart';
import 'package:my_teacher/features/students/domain/enteties/student_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StudentServiseImp implements StudentsServices {
  final StudentStorageService studentStorageService;
  final supabase = Supabase.instance;
  StudentServiseImp({required this.studentStorageService});
  @override
  Future<StudentEntity> addStudent({
    required String name,
    required int lessonId,
    required String tableName,
    required String parentPhone,
    File? image,
    required bool feesPaid,
  }) async {
    try {
      final uuid = Uuid();
      String studentCode = uuid.v4().substring(0, 6).toString();

      if (image != null) {
        final result = await studentStorageService.uploadImage(
          bucketName: 'students',
          file: image,
        );

        if (result.isLeft()) {
          throw Exception(result.fold((fail) => fail, (_) => null));
        }

        final img = result.getOrElse(() => '');
        final student = await supabase.client.from(tableName).insert({
          'name': name,
          'student_code': studentCode,
          'fees_paid': feesPaid,
          'parent_phone': parentPhone,
          'student_image': img,
          'lesson_id': lessonId
        }).select();

        return studentEntity(data: student);
      } else {
        final student = await supabase.client.from(tableName).insert({
          'name': name,
          'student_code': studentCode,
          'fees_paid': feesPaid,
          'parent_phone': parentPhone,
          'lesson_id': lessonId
        }).select();

        return studentEntity(data: student);
      }
    } catch (e) {
      throw Exception('فشل اضافة الطالب');
    }
  }

  @override
  Future<void> deleteStudent(
      {required int studentId,
      required String tableName,
      String? image}) async {
    try {
      if (image != null) {
        var result = await studentStorageService.deleteImage(
            bucketName: 'students', imageName: image);
        if (result.isLeft()) {
          throw Exception('فشل حذف الصوره');
        }
        if (result.isRight()) {
          await supabase.client.from(tableName).delete().eq('id', studentId);
        }
      }
    } catch (e) {
      throw Exception('فشل حذف الطالب');
    }
  }

  @override
  Future<List<StudentEntity>> getStudentsWithPagination({
    required String tableName,
    required int lessonId,
    String? searchName,
    required int page,
    required int limit,
  }) async {
    try {
      final start = page * limit;
      final end = start + limit - 1;

      var query =
          supabase.client.from(tableName).select().eq('lesson_id', lessonId);

      if (searchName != null && searchName.isNotEmpty) {
        query = query.ilike('name', '%${searchName.trim()}%');
      }

      final result = await query.range(start, end);

      return result.map((data) {
        final student = StudentModel.fromJson(data);
        if (student.image != null) {
          final path = supabase.client.storage
              .from('students')
              .getPublicUrl('images/${student.image!}');
          student.image = path;
        }
        return student.studentEntityFromModel();
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  @override
  Future<void> updateStudent(
      {required int studentId,
      required bool feesPayed,
      required String parentPhone,
      required String tableName}) async {
    try {
      await supabase.client
          .from(tableName)
          .update({'fees_paid': feesPayed, 'parent_phone': parentPhone})
          .eq('id', studentId)
          .select();
    } catch (e) {
      throw Exception('فشل تحديث السؤال');
    }
  }

  StudentEntity studentEntity({required List<Map<String, dynamic>> data}) {
    return StudentModel.fromJson(data.first).studentEntityFromModel();
  }
}
