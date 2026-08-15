import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/features/students/presentation/student_cubit/student_cubit.dart';
import 'package:my_teacher/features/students/presentation/views/widgets/add_student_view_body.dart';

class AddStudentView extends StatelessWidget {
  const AddStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentsCubit>(
      create: (context) => getIt<StudentsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('اضافة سؤال'),
        ),
        body: AddStudentViewBody(),
      ),
    );
  }
}
