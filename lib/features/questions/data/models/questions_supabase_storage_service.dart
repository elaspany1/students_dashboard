import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_teacher/core/services/questins_storage_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class SupabaseStorageServices implements QuestinsStorageServices {
  final Supabase _supabase = Supabase.instance;

  @override
  Future<Either<String, String>> uploadImage({
    required String bucketName,
    required File file,
  }) async {
    try {
      final name = p.basename(file.path);
      final uuid = Uuid();
      String studentCode = uuid.v4().substring(0, 6).toString();
      final String imgName = '$studentCode$name';
      await _supabase.client.storage.from(bucketName).upload(
            'images/$imgName',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      return right(imgName); // نخزن الاسم بس
    } catch (e) {
      return left('فشل رفع الصورة: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> deleteImage({
    required String bucketName,
    required String imageName,
  }) async {
    try {
      await _supabase.client.storage
          .from(bucketName)
          .remove(['images/$imageName']);
      return right('تم حذف الصورة');
    } catch (e) {
      return left('فشل حذف الصورة: ${e.toString()}');
    }
  }

  /// لو عايز تحافظ عليها
  @override
  Future<Either<String, String>> updateloadImage({
    required String bucketName,
    required File file,
    required String oldImage,
  }) async {
    try {
      // ✨ ارفع الجديد أولاً
      final uploadResult =
          await uploadImage(bucketName: bucketName, file: file);

      if (uploadResult.isLeft()) {
        return left(
            uploadResult.swap().getOrElse(() => 'فشل رفع الصورة الجديدة'));
      }

      final newImageName = uploadResult.getOrElse(() => '');

      // ✨ لو القديم موجود احذفه بعد نجاح رفع الجديد
      if (oldImage.isNotEmpty) {
        final deleteResult = await deleteImage(
          bucketName: bucketName,
          imageName: oldImage,
        );

        if (deleteResult.isLeft()) {
          // هنا نرجع برضو نجاح بس مع تحذير إن القديم متحذفش
          return right(newImageName);
        }
      }

      return right(newImageName);
    } catch (e) {
      return left('فشل تحديث الصورة: ${e.toString()}');
    }
  }
}
