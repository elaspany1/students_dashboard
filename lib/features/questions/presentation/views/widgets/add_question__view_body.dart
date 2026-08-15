import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/widgets/custom_text_field.dart';
import 'package:my_teacher/features/questions/presentation/question_cubit/question_cubit.dart';

class AddQuestionViewBody extends StatefulWidget {
  const AddQuestionViewBody({super.key});

  @override
  State<AddQuestionViewBody> createState() => _AddQuestionViewState();
}

class _AddQuestionViewState extends State<AddQuestionViewBody> {
  final questionController = TextEditingController();
  final correctAnswer = TextEditingController();

  final option1Controller = TextEditingController();
  final option2Controller = TextEditingController();
  final option3Controller = TextEditingController();
  final option4Controller = TextEditingController();

  final formKey = GlobalKey<FormState>();
  File? file;

  @override
  void dispose() {
    correctAnswer.dispose();
    questionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    option4Controller.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        file = File(picked.path);
      });
    }
  }

  void submit() async {
    if (!formKey.currentState!.validate()) return;

    final options = [
      option1Controller.text.trim(),
      option2Controller.text.trim(),
      option3Controller.text.trim(),
      option4Controller.text.trim(),
    ];

    await context.read<QuestionsCubit>().addQuestions(
          question: questionController.text.trim(),
          options: options,
          lessonId: SelectedIdController.lessonId!,
          correctAnswer:
              correctAnswer.text.trim(), // مؤقتًا الإجابة الصحيحة هي الأولى
          image: file,
        );

    // ignore: use_build_context_synchronously
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: BlocListener<QuestionsCubit, QuestionsState>(
        listener: (context, state) {
          if (state is QuestionsLoading) {
            showDialog(
              context: context,
              barrierDismissible: false, // المستخدم ما يقفلش بإيده
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is AddQuestionsSuccess) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // يقفل اللودينج
            }
            Navigator.pop(context); // يرجع من صفحة الإضافة
          }

          if (state is QuestionsFailure) {
            // يقفل الـ Dialog الأول
            if (Navigator.canPop(context)) Navigator.pop(context);
            // يفتح Dialog بالأيرور
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('خطأ'),
                content: Text(state.message),
              ),
            );
          }
        },
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: questionController,
                labelText: 'السؤال',
                hintText: 'اكتب نص السؤال',
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: option1Controller,
                labelText: 'الإجابة 1',
                hintText: 'أدخل الاختيار الأول',
                onChanged: (value) {},
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: option2Controller,
                labelText: 'الإجابة 2',
                hintText: 'أدخل الاختيار الثاني',
                onChanged: (value) {},
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: option3Controller,
                labelText: 'الإجابة 3',
                hintText: 'أدخل الاختيار الثالث',
                onChanged: (value) {},
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: option4Controller,
                labelText: 'الإجابة 4',
                hintText: 'أدخل الاختيار الرابع',
                onChanged: (value) {},
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: correctAnswer,
                labelText: 'الإجابة الصحيحه',
                hintText: 'أدخل الاجابه الصحيحه',
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              if (file != null)
                CircleAvatar(radius: 40, backgroundImage: FileImage(file!)),
              TextButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text('اختيار صورة (اختياري)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: submit,
                child: const Text('إضافة السؤال'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
