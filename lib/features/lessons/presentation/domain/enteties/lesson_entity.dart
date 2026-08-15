import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final int id;
  final String name;
  final int classId;

  const LessonEntity(
      {required this.id, required this.name, required this.classId});

  @override
  List<Object?> get props => [id, name, classId];
}
