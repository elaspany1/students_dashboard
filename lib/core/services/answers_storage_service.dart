import 'dart:io';

import 'package:dartz/dartz.dart';

abstract class AnswersStorageService {
  Future<Either<String, String>> uploadImage(
      {required String bucketName, required File? file});

  Future<Either<String, String>> deleteImage(
      {required String bucketName, required String imageName});
}
