import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/widgets/dialogs/section_dialog.dart';
import 'package:my_teacher/features/exams/presentation/cubits/lesson_cubit/exams_cubit.dart';
import 'package:my_teacher/features/exams/presentation/views/widgets/exams_view_body.dart';

class ExamsView extends StatefulWidget {
  const ExamsView({super.key});

  @override
  State<ExamsView> createState() => _ExamsViewState();
}

class _ExamsViewState extends State<ExamsView> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    context
        .read<ExamsCubit>()
        .fetchExams(lessonId: SelectedIdController.lessonId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الدروس")),
      body: ExamsViewBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (c) {
                return SectionDialog(
                  confirmText: 'تأكيد',
                  controller: controller,
                  title: 'اضافة امتحان جديد',
                  onConfirm: (value) {
                    BlocProvider.of<ExamsCubit>(context).addExam(
                        name: value, lessonId: SelectedIdController.lessonId!);
                    Navigator.pop(context);
                  },
                );
              });
        },
      ),
    );
  }
}
