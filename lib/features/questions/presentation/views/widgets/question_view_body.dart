import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/features/questions/presentation/question_cubit/question_cubit.dart';
import 'package:my_teacher/features/questions/presentation/views/edit_question_view.dart';
import 'package:my_teacher/features/questions/presentation/views/widgets/question_card.dart';

class QuestionViewBody extends StatefulWidget {
  const QuestionViewBody({super.key});

  @override
  State<QuestionViewBody> createState() => _QuestionViewBodyState();
}

class _QuestionViewBodyState extends State<QuestionViewBody> {
  @override
  void initState() {
    context
        .read<QuestionsCubit>()
        .fetchQuestions(lessonId: SelectedIdController.lessonId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionsCubit, QuestionsState>(
      builder: (context, state) {
        if (state is QuestionsFailure) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is QuestionsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is QuestionsSuccess) {
          return ListView.builder(
              itemCount: state.questions.length,
              itemBuilder: (context, i) {
                return QuestionCard(
                    questionText: state.questions[i].question,
                    options: state.questions[i].options,
                    imageUrl: state.questions[i].image,
                    onEdit: () async {
                      await Navigator.of(context)
                          .push(MaterialPageRoute(builder: (c) {
                        return EditQuestionView(
                          question: state.questions[i],
                        );
                      }));
                      // ignore: use_build_context_synchronously
                      context.read<QuestionsCubit>().fetchQuestions(
                          lessonId: SelectedIdController.lessonId!);
                    },
                    onDelete: () {
                      context.read<QuestionsCubit>().deleteQuestions(
                          questionId: state.questions[i].id,
                          lessonId: SelectedIdController.lessonId!,
                          image: state.questions[i].imageName ?? '');
                    });
              });
        }
        return Container();
      },
    );
  }
}
