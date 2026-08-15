import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  final int id;
  final String question;
  final int lessonId;
  final List<String> options;
  final String? image;
  final String? imageName;
  final String correctAnswer;
  const QuestionEntity(
      {this.imageName,
      required this.correctAnswer,
      required this.id,
      required this.question,
      required this.lessonId,
      required this.options,
      this.image});
  QuestionEntity copyWith({
    String? image,
    String? question,
    List<String>? options,
    String? imageName,
  }) {
    return QuestionEntity(
        id: id,
        image: image ?? this.image,
        question: question ?? this.question,
        options: options ?? this.options,
        lessonId: lessonId,
        imageName: imageName,
        correctAnswer: correctAnswer);
  }

  @override
  List<Object?> get props =>
      [id, question, lessonId, options, image, imageName, correctAnswer];
}
