import 'dart:io';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/services/section_service.dart';
import 'package:my_teacher/features/home/data/models/section_model.dart';
import 'package:my_teacher/features/home/domain/enteties/section_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SectionServiceImp implements SectionService {
  final supabase = Supabase.instance;

  @override
  Future<void> addSection(
      {required String name, required String tableName}) async {
    try {
      await supabase.client.from(tableName).insert({'name': name});
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
  Future<void> deleteSection(
      {required int classId, required String tableName}) async {
    try {
      await supabase.client.from(tableName).delete().eq('class_id', classId);
    } on PostgrestException catch (e) {
      throw Exception('حدث خطأ أثناء حذف القسم: ${e.message}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت.');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء الحذف.');
    }
  }

  @override
  Future<void> updateSection({
    required int classId,
    required String newName,
    required String tableName,
  }) async {
    try {
      await supabase.client
          .from(tableName)
          .update({'name': newName}).eq('class_id', classId);
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

  @override
  Future<List<SectionEntity>> getAllSections(
      {required String tableName}) async {
    try {
      final result = await supabase.client.from(tableName).select();
      return result.map((e) {
        SelectedIdController.classId = e['class_id'];
        return SectionModel.fromJson(e).sectionEntityFromModel();
      }).toList();
    } on PostgrestException catch (e) {
      throw Exception('حدث خطأ أثناء جلب الأقسام: ${e.message}');
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت.');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء جلب الأقسام.');
    }
  }
}
