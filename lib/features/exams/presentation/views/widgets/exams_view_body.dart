import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/widgets/dialogs/confirm_dialog.dart';
import 'package:my_teacher/core/widgets/dialogs/section_dialog.dart';
import 'package:my_teacher/core/widgets/custom_card.dart';
import 'package:my_teacher/features/exams/presentation/cubits/lesson_cubit/exams_cubit.dart';

class ExamsViewBody extends StatefulWidget {
  const ExamsViewBody({super.key});

  @override
  State<ExamsViewBody> createState() => _ExamsViewBodyState();
}

class _ExamsViewBodyState extends State<ExamsViewBody> {
  final nameController = TextEditingController(); // أو أي اسم جدول

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: BlocBuilder<ExamsCubit, ExamsState>(
        builder: (context, state) {
          if (state is ExamsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExamsSuccess) {
            return ListView.builder(
              itemCount: state.exams.length,
              itemBuilder: (context, index) {
                final exam = state.exams[index];
                return CustomCard(
                    sectionName: exam.name,
                    onEdit: () {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return SectionDialog(
                              confirmText: 'تأكيد',
                              controller: nameController,
                              title: 'اضافة قسم جديد',
                              onConfirm: (value) async {
                                await BlocProvider.of<ExamsCubit>(context)
                                    .updateExam(
                                        id: exam.id,
                                        newName: value,
                                        lessonId:
                                            SelectedIdController.lessonId!);
                                // ignore: use_build_context_synchronously
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
                              onConfirm: () async {
                                await BlocProvider.of<ExamsCubit>(context)
                                    .deleteExam(
                                        id: exam.id,
                                        lessonId:
                                            SelectedIdController.lessonId!);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              });
                        },
                      );
                    });
              },
            );
          } else if (state is ExamsFailure) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
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
