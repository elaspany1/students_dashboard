import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/features/questions/domain/enteties/question_entity.dart';
import 'package:my_teacher/features/questions/presentation/question_cubit/question_cubit.dart';
import 'package:my_teacher/features/questions/presentation/views/widgets/edit_question_view_body.dart';

class EditQuestionView extends StatelessWidget {
  final QuestionEntity question;

  const EditQuestionView({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuestionsCubit>(
      create: (context) => getIt<QuestionsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('اضافة سؤال'),
        ),
        body: EditQuestionViewBody(
          question: question,
        ),
      ),
    );
  }
}
