import 'package:my_teacher/features/questions/domain/enteties/question_entity.dart';

class QuestionModel {
  final int id;
  final String question;
  final int lessonId;
  final List<String> options;
  final String? image;
  String? imageName;
  final String correctAnswer;
  QuestionModel(
      {this.imageName,
      required this.correctAnswer,
      required this.id,
      required this.question,
      required this.lessonId,
      required this.options,
      this.image});
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
        id: json['id'],
        question: json['question_text'],
        correctAnswer: json['correct_answer'],
        lessonId: json['lesson_id'],
        options: List<String>.from(json['options']),
        image: json['question_image'],
        imageName: json['question_image']);
  }
  QuestionEntity questionEntityFromModel() {
    return QuestionEntity(
        id: id,
        correctAnswer: correctAnswer,
        question: question,
        lessonId: lessonId,
        options: options,
        image: image,
        imageName: imageName);
  }
}
