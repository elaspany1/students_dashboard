import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_teacher/core/services/answers_storage_service.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnswersSupabaseStorageService implements AnswersStorageService {
  final Supabase _supabase = Supabase.instance;
  @override
  Future<Either<String, String>> deleteImage(
      {required String bucketName, required String imageName}) async {
    try {
      await _supabase.client.storage
          .from(bucketName)
          .remove(['images/$imageName']);
      return right('تم حذف الصوره');
    } catch (e) {
      return left('فشل حذف الصوره');
    }
  }

  @override
  Future<Either<String, String>> uploadImage(
      {required String bucketName, required File? file}) async {
    try {
      String name = basename(file!.path);
      await _supabase.client.storage
          .from(bucketName)
          .upload('images/$name', file);
      String imgName = basename(file.path);
      return right(imgName);
    } catch (e) {
      return left('فشل رفع الصوره');
    }
  }
}
