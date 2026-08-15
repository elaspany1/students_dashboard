import 'package:my_teacher/features/students/domain/enteties/student_entity.dart';

class StudentModel {
  final int id;
  final String name;
  final int lessonId;
  final String parentPhone;
  final String studentCode;
  final bool feesPaid;
  String? image;
  String? imageName;

  StudentModel(
      {this.imageName,
      this.image,
      required this.id,
      required this.name,
      required this.lessonId,
      required this.parentPhone,
      required this.studentCode,
      required this.feesPaid});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
        id: json['id'],
        name: json['name'],
        lessonId: json['lesson_id'],
        parentPhone: json['parent_phone'],
        studentCode: json['student_code'],
        feesPaid: json['fees_paid'],
        image: json['student_image'],
        imageName: json['student_image']);
  }
  StudentEntity studentEntityFromModel() {
    return StudentEntity(
        id: id,
        name: name,
        imageName: imageName,
        lessonId: lessonId,
        studentCode: studentCode,
        parentPhone: parentPhone,
        feesPaid: feesPaid,
        image: image);
  }
}
