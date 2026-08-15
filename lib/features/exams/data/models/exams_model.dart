import 'package:my_teacher/features/exams/presentation/domain/enteties/exam_entity.dart';

class ExamsModel {
  final int id;
  final String name;
  final int lessonId;
  ExamsModel({required this.id, required this.name, required this.lessonId});
  factory ExamsModel.fromJson(Map<String, dynamic> data) {
    return ExamsModel(
        id: data['id'], name: data['title'], lessonId: data['lesson_id']);
  }
  ExamEntity examEntityFromModel() {
    return ExamEntity(id: id, name: name, lessonId: lessonId);
  }
}
