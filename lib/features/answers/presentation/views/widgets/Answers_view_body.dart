import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/widgets/custom_text_field.dart';
import 'package:my_teacher/features/answers/presentation/answers_cubit/answers_cubit.dart';
import 'package:my_teacher/features/answers/presentation/views/widgets/answers_card.dart';

class AnswersViewBody extends StatefulWidget {
  const AnswersViewBody({super.key});

  @override
  State<AnswersViewBody> createState() => _AnswersViewBodyState();
}

class _AnswersViewBodyState extends State<AnswersViewBody> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    context.read<AnswersCubit>().getAllAnswers(
          lessonId: SelectedIdController.lessonId!,
          reset: true,
        );

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        context.read<AnswersCubit>().getAllAnswers(
            lessonId: SelectedIdController.lessonId!, reset: false);
      }
    });
  }

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<AnswersCubit>().getAllAnswers(
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
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('تأكيد الحذف'),
                content: const Text(
                    'هل أنت متأكد أنك تريد مسح جميع الإجابات والصور؟'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AnswersCubit>().clearAllAnswers();
                    },
                    child: const Text('مسح الكل'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.delete_forever),
          label: const Text('مسح كل الإجابات'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
        Expanded(
          child: BlocBuilder<AnswersCubit, AnswersState>(
            builder: (context, state) {
              if (state is AnswersFailure) {
                return Center(child: Text(state.message));
              }

              if (state is AnswersLoading && state.answers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final answers = state.answers;

              if (answers.isEmpty) {
                return const Center(child: Text('لا يوجد طلاب'));
              }

              return ListView.builder(
                controller: scrollController,
                itemCount: answers.length + 1,
                itemBuilder: (context, i) {
                  if (i < answers.length) {
                    final answer = answers[i];
                    return AnswerCard(
                      name: answer.name!,
                      imageUrl: answer.image,
                      answers: answer.answers,
                    );
                  } else {
                    return state is AnswersLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox();
                  }
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
