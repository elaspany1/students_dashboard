import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_teacher/core/constants/selected_controller.dart';
import 'package:my_teacher/core/widgets/custom_text_field.dart';
import 'package:my_teacher/features/students/presentation/student_cubit/student_cubit.dart';

class AddStudentViewBody extends StatefulWidget {
  const AddStudentViewBody({super.key});

  @override
  State<AddStudentViewBody> createState() => _AddStudentViewBodyState();
}

class _AddStudentViewBodyState extends State<AddStudentViewBody> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final parentPhoneController = TextEditingController();
  bool feesPayed = false;
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة طالب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: nameController,
                labelText: 'اسم الطالب',
                hintText: 'اكتب اسم الطالب',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: parentPhoneController,
                labelText: 'ادخل رقم ولي الامر',
                hintText: 'أدخل رقم ولي الامر',
              ),
              const SizedBox(height: 12),
              if (file != null)
                CircleAvatar(radius: 40, backgroundImage: FileImage(file!)),
              TextButton.icon(
                onPressed: () async {
                  final picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      file = File(picked.path);
                    });
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text('اختيار صورة (اختياري)'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text("المصاريف مدفوعة"),
                value: feesPayed,
                onChanged: (v) => setState(() => feesPayed = v),
              ),
              BlocListener<StudentsCubit, StudentsState>(
                listener: (context, state) {
                  if (state is StudentsLoading) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(child: CircularProgressIndicator());
                        });
                  }
                  if (state is AddStudentSuccess) {
                    Navigator.pop(context);
                    Navigator.pop(
                        context, state.studentEntity); // يرجع الـ StudentEntity
                  }

                  if (state is StudentsFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<StudentsCubit>().addStudent(
                            name: nameController.text.trim(),
                            lessonId: SelectedIdController.lessonId!,
                            parentPhone: parentPhoneController.text.trim(),
                            feesPaid: feesPayed,
                            image: file,
                          );
                    }
                  },
                  child: const Text('إضافة الطالب'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
