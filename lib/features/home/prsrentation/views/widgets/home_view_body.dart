import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/core/widgets/dialogs/confirm_dialog.dart';
import 'package:my_teacher/core/widgets/dialogs/section_dialog.dart';
import 'package:my_teacher/features/home/prsrentation/cubits/sections_cubit/sections_cubit.dart';
import 'package:my_teacher/core/widgets/custom_card.dart';
import 'package:my_teacher/features/lessons/presentation/cubits/lesson_cubit/lesson_cubit.dart';
import 'package:my_teacher/features/lessons/presentation/views/lesson_view.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final nameController = TextEditingController(); // أو أي اسم جدول

  @override
  void initState() {
    super.initState();

    context.read<SectionsCubit>().fetchSections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: BlocConsumer<SectionsCubit, SectionsState>(
        listener: (context, state) {
          if (state is SectionsFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is SectionsSuccess) {
            return ListView.builder(
              itemCount: state.sections.length,
              itemBuilder: (context, index) {
                final section = state.sections[index];
                nameController.text = section.name;
                return CustomCard(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        SelectedIdController.classId = section.id;
                        return BlocProvider<LessonCubit>(
                          create: (context) => getIt<LessonCubit>(),
                          child: LessonView(),
                        );
                      }));
                    },
                    sectionName: section.name,
                    onEdit: () {
                      showDialog(
                          context: context,
                          builder: (c) {
                            return SectionDialog(
                              confirmText: 'تأكيد',
                              controller: nameController,
                              title: 'تعديل القسم',
                              onConfirm: (value) {
                                BlocProvider.of<SectionsCubit>(context)
                                    .updateSection(section.id, value);
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
                                BlocProvider.of<SectionsCubit>(context)
                                    .deleteSection(section.id);
                                Navigator.pop(context);
                              });
                        },
                      );
                    });
              },
            );
          } else if (state is SectionsLoading) {
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
