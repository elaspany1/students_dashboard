import 'dart:io';

import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/services/lessons_services.dart';
import 'package:my_teacher/features/lessons/data/models/lesson_model.dart';
import 'package:my_teacher/features/lessons/presentation/domain/enteties/lesson_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LessonServiceImpl implements LessonService {
  final supabase = Supabase.instance;

  @override
  Future<void> addLesson(
      {required String name,
      required String tableName,
      required int classId}) async {
    try {
      await supabase.client
          .from(tableName)
          .insert({'title': name, 'class_id': classId});
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // unique_violation
        throw Exception('هذا الاسم مستخدم بالفعل.');
      }
      throw Exception('حدث خطأ أثناء إضافة القسم: ${e.message}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت.');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء الإضافة.');
    }
  }

  @override
  Future<void> deleteLesson(
      {required int lessonId, required String tableName}) async {
    try {
      await supabase.client.from(tableName).delete().eq('id', lessonId);
    } on PostgrestException catch (e) {
      throw Exception('حدث خطأ أثناء حذف القسم: ${e.message}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت.');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء الحذف.');
    }
  }

  @override
  Future<List<LessonEntity>> getAllLessons(
      {required String tableName, required int classId}) async {
    try {
      final result = await supabase.client
          .from(tableName)
          .select()
          .eq('class_id', classId);
      return result.map((e) {
        SelectedIdController.lessonId = e['lesson_id'];
        return LessonModel.fromJson(e).lessonEntityFromModel();
      }).toList();
    } on PostgrestException catch (e) {
      throw Exception('حدث خطأ أثناء جلب الأقسام: ${e.message}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateLesson(
      {required int lessonId,
      required String newName,
      required String tableName}) async {
    try {
      await supabase.client
          .from(tableName)
          .update({'title': newName}).eq('id', lessonId);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception('هذا الاسم مستخدم بالفعل.');
      }
      throw Exception('حدث خطأ أثناء التعديل: ${e.message}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت.');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء التعديل.');
    }
  }
}
