import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:my_teacher/core/services/questins_storage_services.dart';
import 'package:my_teacher/core/services/question_services.dart';
import 'package:my_teacher/features/questions/data/models/question_model.dart';
import 'package:my_teacher/features/questions/domain/enteties/question_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionServiseImpl implements QuestionServices {
  final supabase = Supabase.instance;
  final QuestinsStorageServices questinsStorageServices;

  QuestionServiseImpl({required this.questinsStorageServices});

  // Helper: دايمًا يجيب ملف الصورة الافتراضية
  Future<File> _getDefaultImageFile() async {
    final byteData = await rootBundle.load('assets/images/unnamed.png');
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/unnamed.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  @override
  Future<void> addQuestion(
      {required String question,
      required List<String> options,
      required int lessonId,
      required String correctAnswer,
      File? image}) async {
    try {
      // لو مفيش صورة → هات الافتراضية
      final fileToUpload = image ?? await _getDefaultImageFile();

      final img = await questinsStorageServices.uploadImage(
        bucketName: 'questions',
        file: fileToUpload,
      );

      if (img.isLeft()) throw Exception('فشل تحميل الصورة');

      final imageName = img.getOrElse(() => '');

      await supabase.client.from('questions').insert({
        'question_text': question,
        'options': options,
        'lesson_id': lessonId,
        'question_image': imageName,
        'correct_answer': correctAnswer
      });
    } catch (e) {
      throw Exception('فشل إضافة السؤال: $e');
    }
  }

  @override
  Future<void> deleteQuestion({required int questionId, String? image}) async {
    try {
      if (image!.isNotEmpty) {
        final result = await questinsStorageServices.deleteImage(
          bucketName: 'questions',
          imageName: image,
        );
        if (result.isLeft()) {
          throw Exception('فشل حذف الصورة');
        }
      }
      await supabase.client.from('questions').delete().eq('id', questionId);
    } catch (e) {
      throw Exception('فشل حذف السؤال');
    }
  }

  @override
  Future<List<QuestionEntity>> getAllQuestions({required int lessonId}) async {
    try {
      final response = await supabase.client
          .from('questions')
          .select()
          .eq('lesson_id', lessonId);

      List<QuestionEntity> questionsEntity = response
          .map((q) => QuestionModel.fromJson(q).questionEntityFromModel())
          .toList();

      final newList = questionsEntity.map((element) {
        if (element.image != null && element.image!.isNotEmpty) {
          final imageUrl = supabase.client.storage
              .from('questions')
              .getPublicUrl('images/${element.image}');
          return element.copyWith(image: imageUrl, imageName: element.image);
        } else {
          return element;
        }
      }).toList();

      return newList;
    } catch (e) {
      throw Exception('فشل في جلب الأسئلة: $e');
    }
  }

  @override
  Future<void> updateQuestion({
    required int questionId,
    required String newQuestion,
    required String correctAnswer,
    String? image,
    File? file,
    required List<String> options,
  }) async {
    try {
      Map<String, dynamic> data = {
        'question_text': newQuestion,
        'options': options,
        'correct_answer': correctAnswer,
      };

      if (file != null) {
        final img = await questinsStorageServices.updateloadImage(
          oldImage: image ?? '',
          bucketName: 'questions',
          file: file,
        );

        if (img.isLeft()) {
          throw Exception(img.swap().getOrElse(() => 'فشل رفع الصورة'));
        }

        final imageName = img.getOrElse(() => '');
        data['question_image'] = imageName;
      }

      await supabase.client.from('questions').update(data).eq('id', questionId);
    } catch (e) {
      throw Exception('فشل تعديل السؤال: $e');
    }
  }
}
