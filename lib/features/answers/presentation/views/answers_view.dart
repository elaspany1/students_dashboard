import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/features/answers/presentation/answers_cubit/answers_cubit.dart';
import 'package:my_teacher/features/answers/presentation/views/widgets/Answers_view_body.dart';

class AnswersView extends StatelessWidget {
  const AnswersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnswersCubit>(
      create: (context) => getIt<AnswersCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('الطلاب'),
        ),
        body: AnswersViewBody(),
      ),
    );
  }
}
