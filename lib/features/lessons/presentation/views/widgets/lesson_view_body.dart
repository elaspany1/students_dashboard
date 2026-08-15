import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/widgets/dialogs/confirm_dialog.dart';
import 'package:my_teacher/core/widgets/dialogs/section_dialog.dart';
import 'package:my_teacher/core/widgets/custom_card.dart';
import 'package:my_teacher/features/lessons/presentation/cubits/lesson_cubit/lesson_cubit.dart';
import 'package:my_teacher/features/lessons/presentation/views/lesson_dashboard_view.dart';

class LessonViewBody extends StatefulWidget {
  const LessonViewBody({super.key});

  @override
  State<LessonViewBody> createState() => _LessonViewBodyState();
}

class _LessonViewBodyState extends State<LessonViewBody> {
  final nameController = TextEditingController(); // أو أي اسم جدول

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: BlocConsumer<LessonCubit, LessonState>(
        listener: (context, state) {
          if (state is LessonFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is LesssonSuccess) {
            return ListView.builder(
              itemCount: state.lessons.length,
              itemBuilder: (context, index) {
                final lesson = state.lessons[index];
                return CustomCard(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (c) {
                        SelectedIdController.lessonId = lesson.id;

                        return LessonDashboardView();
                      }));
                    },
                    sectionName: lesson.name,
                    onEdit: () {
                      nameController.text = lesson.name;
                      showDialog(
                          context: context,
                          builder: (c) {
                            return SectionDialog(
                              confirmText: 'تأكيد',
                              controller: nameController,
                              title: 'تعديل الدرس',
                              onConfirm: (value) {
                                BlocProvider.of<LessonCubit>(context)
                                    .updateLesson(
                                        id: lesson.id, newName: value);
                                Navigator.pop(context);
                              },
                            );
                          });
                    },
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (c) {
                          return ConfirmDialog(
                              title: 'حذف القسم',
                              message: 'حذف',
                              confirmText: 'حذف حذ',
                              onConfirm: () {
                                BlocProvider.of<LessonCubit>(context)
                                    .deleteLesson(id: lesson.id);
                                Navigator.pop(context);
                              });
                        },
                      );
                    });
              },
            );
          } else if (state is LessonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
