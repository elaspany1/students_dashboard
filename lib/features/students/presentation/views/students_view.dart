import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/features/students/presentation/student_cubit/student_cubit.dart';
import 'package:my_teacher/features/students/presentation/views/add_student_view.dart';
import 'package:my_teacher/features/students/presentation/views/widgets/students_view_body.dart';

class StudentsView extends StatelessWidget {
  const StudentsView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentsCubit>(
      create: (context) => getIt<StudentsCubit>(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('الطلاب'),
          ),
          body: StudentsViewBody(),
          floatingActionButton: _AddFab()),
    );
  }
}

class _AddFab extends StatelessWidget {
  const _AddFab();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final student = await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddStudentView()),
        );
        if (student != null) {
          // عرض الـ dialog مباشرة بعد الإضافة
          showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (_) => AlertDialog(
              title: Text(student.studentCode),
              content: Text(student.name),
            ),
          );

          // تحديث القائمة بعد الإضافة
          // ignore: use_build_context_synchronously
          context.read<StudentsCubit>().getAllStudents(
                lessonId: SelectedIdController.lessonId!,
                reset: true,
              );
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
