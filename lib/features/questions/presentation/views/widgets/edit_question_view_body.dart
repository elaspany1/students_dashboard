import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/widgets/custom_text_field.dart';
import 'package:my_teacher/features/questions/domain/enteties/question_entity.dart';
import 'package:my_teacher/features/questions/presentation/question_cubit/question_cubit.dart';

class EditQuestionViewBody extends StatefulWidget {
  final QuestionEntity question;

  const EditQuestionViewBody({super.key, required this.question});

  @override
  State<EditQuestionViewBody> createState() => _EditQuestionViewBodyState();
}

class _EditQuestionViewBodyState extends State<EditQuestionViewBody> {
  File? file;
  late TextEditingController questionController;
  final correctAnswer = TextEditingController();
  late TextEditingController answerController;
  late List<TextEditingController> optionControllers;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    answerController =
        TextEditingController(text: widget.question.correctAnswer);
    questionController = TextEditingController(text: widget.question.question);
    optionControllers = List.generate(
      widget.question.options.length,
      (index) => TextEditingController(text: widget.question.options[index]),
    );
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

    final options = List.generate(
        optionControllers.length, (i) => optionControllers[i].text);

    await context.read<QuestionsCubit>().updateQuestions(
        file: file,
        image: widget.question.imageName,
        questionId: widget.question.id,
        newQuestion: questionController.text,
        options: options,
        correctAnswer: correctAnswer.text,
        lessonId: SelectedIdController.lessonId!);

    // ignore: use_build_context_synchronously
  }

  @override
  void dispose() {
    questionController.dispose();
    correctAnswer.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<QuestionsCubit, QuestionsState>(
        listener: (context, state) {
          if (state is QuestionsLoading) {
            showDialog(
              context: context,
              barrierDismissible: false, // المستخدم ما يقفلش بإيده
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is UpdateQuestionsSuccess) {
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
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: questionController,
                  labelText: questionController.text,
                  hintText: '',
                  onChanged: (value) {},
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return CustomTextField(
                        controller: optionControllers[i],
                        labelText: optionControllers[i].text,
                        hintText: '',
                        onChanged: (value) {},
                      );
                    },
                    separatorBuilder: (context, i) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: optionControllers.length),
                CustomTextField(
                  controller: correctAnswer,
                  labelText: 'ادخل الاجابه',
                  hintText: '',
                  onChanged: (value) {},
                ),
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
                  child: const Text('حفظ التعديل'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
