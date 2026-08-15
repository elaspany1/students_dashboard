part of 'student_cubit.dart';

abstract class StudentsState {
  final List<StudentEntity> students;
  const StudentsState(this.students);
}

class StudentsInitial extends StudentsState {
  const StudentsInitial() : super(const []);
}

class StudentsLoading extends StudentsState {
  const StudentsLoading(super.students);
}

class StudentsSuccess extends StudentsState {
  const StudentsSuccess(super.students);
}

class AddStudentSuccess extends StudentsState {
  final StudentEntity studentEntity;
  const AddStudentSuccess(super.students, this.studentEntity);
}

class StudentsFailure extends StudentsState {
  final String message;
  const StudentsFailure(this.message, List<StudentEntity> students)
      : super(students);
}

class UpdateStudentSuccess extends StudentsState {
  const UpdateStudentSuccess(super.students);
}
