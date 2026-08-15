import 'package:my_teacher/features/lessons/presentation/domain/enteties/lesson_entity.dart';

class LessonModel {
  final int id;
  final String name;
  final int classId;
  LessonModel({required this.id, required this.name, required this.classId});
  factory LessonModel.fromJson(Map<String, dynamic> data) {
    return LessonModel(
        id: data['id'], name: data['title'], classId: data['class_id']);
  }
  LessonEntity lessonEntityFromModel() {
    return LessonEntity(id: id, name: name, classId: classId);
  }
}
