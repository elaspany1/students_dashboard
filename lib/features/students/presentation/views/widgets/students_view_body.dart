import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/widgets/custom_text_field.dart';
import 'package:my_teacher/features/students/presentation/student_cubit/student_cubit.dart';
import 'package:my_teacher/features/students/presentation/views/edit_student_view.dart';
import 'package:my_teacher/features/students/presentation/views/widgets/student_card.dart';

class StudentsViewBody extends StatefulWidget {
  const StudentsViewBody({super.key});

  @override
  State<StudentsViewBody> createState() => _StudentsViewBodyState();
}

class _StudentsViewBodyState extends State<StudentsViewBody> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    context.read<StudentsCubit>().getAllStudents(
          lessonId: SelectedIdController.lessonId!,
          reset: true,
        );

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        context.read<StudentsCubit>().getAllStudents(
              lessonId: SelectedIdController.lessonId!,
              reset: false,
            );
      }
    });
  }

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<StudentsCubit>().getAllStudents(
            lessonId: SelectedIdController.lessonId!,
            searchQuery: value.trim(),
            reset: true,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            hintText: 'ابحث باسم الطالب',
            controller: searchController,
            labelText: 'بحث',
            onChanged: (v) {
              onSearchChanged(v);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<StudentsCubit, StudentsState>(
            builder: (context, state) {
              return BlocBuilder<StudentsCubit, StudentsState>(
                builder: (context, state) {
                  if (state is StudentsFailure) {
                    return Center(child: Text(state.message));
                  }

                  if (state is StudentsLoading && state.students.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final students = state.students;

                  if (students.isEmpty) {
                    return const Center(child: Text('لا يوجد طلاب'));
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: students.length + 1,
                    itemBuilder: (context, i) {
                      if (i < students.length) {
                        final student = students[i];

                        return StudentCard(
                          name: student.name,
                          onEdit: () async {
                            await Navigator.of(context)
                                .push(MaterialPageRoute(builder: (c) {
                              return EditStudentView(
                                student: student,
                              );
                            }));
                            // ignore: use_build_context_synchronously
                            context.read<StudentsCubit>().getAllStudents(
                                  lessonId: SelectedIdController.lessonId!,
                                  reset: true,
                                );
                          }
                          // ignore: use_build_context_synchronously
                          ,
                          onDelete: () {
                            context.read<StudentsCubit>().deleteStudent(
                                studentId: student.id,
                                image: student.imageName ?? '');
                          },
                          imageUrl: student.image,
                          studentCode: student.studentCode,
                          parentPhone: student.parentPhone ?? '01000000',
                          feesPayed: student.feesPaid,
                        );
                      } else {
                        return state is StudentsLoading
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox();
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
