import 'package:dartz/dartz.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/errors/class_failure.dart';
import 'package:my_teacher/core/services/answers_services.dart';
import 'package:my_teacher/features/answers/domain/enteties/answers_entity.dart';

class AnswersRepo {
  final AnswersServices answersServices;

  AnswersRepo({required this.answersServices});

  Future<Either<Failure, List<AnswersEntity>>> getAllAnswers({
    String? searchName, // البحث
    required int page, // رقم الصفحة
    required int limit,
  }) async {
    try {
      final result = await answersServices.getAnswerssWithPagination(
        tableName: 'answers',
        lessonId: SelectedIdController.lessonId!,
        searchName: searchName?.trim(),
        page: page,
        limit: limit,
      );

      return right(result);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> clearAllAnswers() async {
    try {
      await answersServices.clearAllAnswers();
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
