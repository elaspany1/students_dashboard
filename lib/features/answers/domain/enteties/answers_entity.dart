import 'package:equatable/equatable.dart';

class AnswersEntity extends Equatable {
  final int id;
  final int lessonId;
  final List<String> answers;
  final String? name;
  final String? image;
  const AnswersEntity({
    required this.answers,
    this.image,
    required this.id,
    required this.lessonId,
    required this.name,
  });
  AnswersEntity copyWith({
    required String imagePath,
  }) {
    return AnswersEntity(
      image: image,
      id: id,
      lessonId: lessonId,
      answers: answers,
      name: name,
    );
  }

  @override
  List<Object?> get props => [id, name, lessonId, image, answers];
}
