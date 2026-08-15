import 'dart:io';

import 'package:my_teacher/core/services/exams_service.dart';
import 'package:my_teacher/features/exams/data/models/exams_model.dart';
import 'package:my_teacher/features/exams/presentation/domain/enteties/exam_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExamsServiceImpl implements ExamsService {
  final supabase = Supabase.instance;

  @override
  Future<void> addExam(
      {required String name,
      required String tableName,
      required int lessonId}) async {
    try {
      await supabase.client
          .from(tableName)
          .insert({'title': name, 'lesson_id': lessonId});
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
  Future<void> deleteExam(
      {required int examId, required String tableName}) async {
    try {
      await supabase.client.from(tableName).delete().eq('id', examId);
    } on PostgrestException catch (e) {
      throw Exception('حدث خطأ أثناء حذف القسم: ${e.message}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت.');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء الحذف.');
    }
  }

  @override
  Future<List<ExamEntity>> getAllExams(
      {required String tableName, required int lessonId}) async {
    final result = await supabase.client
        .from(tableName)
        .select()
        .eq('lesson_id', lessonId)
        .order('id', ascending: false); // 👈 ترتيب ثابت مهم

    final list = result
        .map((e) => ExamsModel.fromJson(e).examEntityFromModel())
        .toList();

    return list;
  }

  @override
  Future<void> updateExam(
      {required int examId,
      required String newName,
      required String tableName}) async {
    try {
      await supabase.client
          .from(tableName)
          .update({'title': newName}).eq('id', examId);
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
