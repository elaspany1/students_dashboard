import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/features/questions/presentation/question_cubit/question_cubit.dart';
import 'package:my_teacher/features/questions/presentation/views/add_question_view.dart';
import 'package:my_teacher/features/questions/presentation/views/widgets/question_view_body.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuestionsCubit>(
      create: (context) => getIt<QuestionsCubit>(),
      child:
          Scaffold(body: QuestionViewBody(), floatingActionButton: _AddFab()),
    );
  }
}

// ignore: unused_element
class _AddFab extends StatelessWidget {
  const _AddFab();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddQuestionView()),
        );
        // بعد ما ترجع من صفحة الإضافة اطلب refresh
        // ignore: use_build_context_synchronously
        context
            .read<QuestionsCubit>()
            .fetchQuestions(lessonId: SelectedIdController.lessonId!);
      },
      child: const Icon(Icons.add),
    );
  }
}
