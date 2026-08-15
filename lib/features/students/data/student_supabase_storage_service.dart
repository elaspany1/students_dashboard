import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_teacher/core/services/student_storage_service.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StudentSupabaseStorageService implements StudentStorageService {
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
      final uuid = Uuid();
      String imageCode = uuid.v4().substring(0, 6).toString();
      String name = basename(file!.path);
      final String newImgName = '$imageCode$name';
      await _supabase.client.storage
          .from(bucketName)
          .upload('images/$newImgName', file);

      return right(newImgName);
    } catch (e) {
      return left('فشل رفع الصوره');
    }
  }
}
