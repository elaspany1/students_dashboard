import 'package:equatable/equatable.dart';

class ExamEntity extends Equatable {
  final int id;
  final String name;
  final int lessonId;

  const ExamEntity(
      {required this.id, required this.name, required this.lessonId});

  @override
  List<Object?> get props => [id, name, lessonId];
}
