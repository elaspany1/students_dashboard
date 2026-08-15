import 'package:my_teacher/features/answers/domain/enteties/answers_entity.dart';

class AnswersModel {
  final int id;
  final String name;
  final int lessonId;
  final List<String> answers;
  String? image;

  AnswersModel({
    this.image,
    required this.id,
    required this.name,
    required this.lessonId,
    required this.answers,
  });

  factory AnswersModel.fromJson(Map<String, dynamic> json) {
    return AnswersModel(
      id: json['id'] as int,
      name: json['name'] as String,
      lessonId: json['lesson_id'] as int,
      answers: (json['student_answers'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      image: json['student_image'] as String?,
    );
  }
  AnswersEntity answerEntityFromModel() {
    return AnswersEntity(
        id: id, name: name, lessonId: lessonId, answers: answers, image: image);
  }
}
