import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/widgets/dialogs/section_dialog.dart';
import 'package:my_teacher/features/lessons/presentation/cubits/lesson_cubit/lesson_cubit.dart';
import 'package:my_teacher/features/lessons/presentation/views/widgets/lesson_view_body.dart';

class LessonView extends StatefulWidget {
  const LessonView({super.key});

  @override
  State<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    context
        .read<LessonCubit>()
        .fetchLessons(classId: SelectedIdController.classId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الدروس")),
      body: LessonViewBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (c) {
                return SectionDialog(
                  confirmText: 'تأكيد',
                  controller: controller,
                  title: 'اضافة درس جديد',
                  onConfirm: (value) {
                    BlocProvider.of<LessonCubit>(context).addLesson(
                        name: value, classId: SelectedIdController.classId!);
                    Navigator.pop(context);
                  },
                );
              });
        },
      ),
    );
  }
}
