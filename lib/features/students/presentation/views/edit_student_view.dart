import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/features/students/domain/enteties/student_entity.dart';
import 'package:my_teacher/features/students/presentation/student_cubit/student_cubit.dart';
import 'package:my_teacher/features/students/presentation/views/widgets/edit_student_view_body.dart';

class EditStudentView extends StatelessWidget {
  final StudentEntity student;

  const EditStudentView({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentsCubit>(
      create: (context) => getIt<StudentsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('اضافة سؤال'),
        ),
        body: EditStudentViewBody(
          student: student,
        ),
      ),
    );
  }
}
