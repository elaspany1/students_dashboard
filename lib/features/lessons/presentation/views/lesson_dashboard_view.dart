import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/core/widgets/custom_button.dart';
import 'package:my_teacher/features/answers/presentation/views/answers_view.dart';
import 'package:my_teacher/features/exams/presentation/cubits/lesson_cubit/exams_cubit.dart';
import 'package:my_teacher/features/exams/presentation/views/exams_view.dart';
import 'package:my_teacher/features/questions/presentation/views/question_view.dart';
import 'package:my_teacher/features/students/presentation/views/students_view.dart';

class LessonDashboardView extends StatefulWidget {
  const LessonDashboardView({super.key});

  @override
  State<LessonDashboardView> createState() => _LessonDashboardViewState();
}

class _LessonDashboardViewState extends State<LessonDashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomButton(
              text: 'عرض الطلاب',
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return StudentsView();
                }));
              }),
          SizedBox(
            height: 10.h,
          ),
          CustomButton(
              text: 'عرض الاسئله',
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return QuestionView();
                }));
              }),
          SizedBox(
            height: 10.h,
          ),
          CustomButton(
              text: 'عرض الامتحانات',
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return BlocProvider<ExamsCubit>(
                    create: (context) => getIt<ExamsCubit>(),
                    child: ExamsView(),
                  );
                }));
              }),
          SizedBox(
            height: 10.h,
          ),
          CustomButton(
              text: 'عرض الاجابات',
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AnswersView()));
              }),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
