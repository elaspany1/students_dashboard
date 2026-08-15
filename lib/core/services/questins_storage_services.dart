import 'dart:io';

import 'package:dartz/dartz.dart';

abstract class QuestinsStorageServices {
  Future<Either<String, String>> uploadImage(
      {required String bucketName, required File file});
  Future<Either<String, String>> updateloadImage(
      {required String bucketName,
      required File file,
      required String oldImage});
  Future<Either<String, String>> deleteImage(
      {required String bucketName, required String imageName});
}
