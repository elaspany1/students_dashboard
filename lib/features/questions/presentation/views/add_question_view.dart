import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/features/questions/presentation/question_cubit/question_cubit.dart';
import 'package:my_teacher/features/questions/presentation/views/widgets/add_question__view_body.dart';

class AddQuestionView extends StatelessWidget {
  const AddQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuestionsCubit>(
      create: (context) => getIt<QuestionsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('اضافة سؤال'),
        ),
        body: AddQuestionViewBody(),
      ),
    );
  }
}
