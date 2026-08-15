import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  final int id;
  final String name;
  final int lessonId;
  final String studentCode;
  final String? parentPhone;
  final bool feesPaid;
  final String? image;
  final String? imageName;
  const StudentEntity(
      {this.imageName,
      this.image,
      required this.feesPaid,
      required this.id,
      required this.name,
      required this.lessonId,
      required this.studentCode,
      this.parentPhone});
  StudentEntity copyWith({required String imagePath}) {
    return StudentEntity(
        image: imagePath,
        imageName: imageName,
        feesPaid: feesPaid,
        id: id,
        name: name,
        lessonId: lessonId,
        studentCode: studentCode);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        lessonId,
        studentCode,
        parentPhone,
        feesPaid,
        image,
        imageName
      ];
}
