import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/widgets/custom_text_field.dart';
import 'package:my_teacher/features/students/domain/enteties/student_entity.dart';
import 'package:my_teacher/features/students/presentation/student_cubit/student_cubit.dart';

class EditStudentViewBody extends StatefulWidget {
  final StudentEntity student;

  const EditStudentViewBody({super.key, required this.student});

  @override
  State<EditStudentViewBody> createState() => _EditStudentViewBodyState();
}

class _EditStudentViewBodyState extends State<EditStudentViewBody> {
  late TextEditingController nameController;
  late TextEditingController parentPhoneController;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool feesPayed = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.student.name);

    parentPhoneController =
        TextEditingController(text: widget.student.parentPhone);
    feesPayed = widget.student.feesPaid;
  }

  @override
  void dispose() {
    nameController.dispose();
    parentPhoneController.dispose();
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;

    context.read<StudentsCubit>().updateStudent(
          studentId: widget.student.id,
          feesPayed: feesPayed,
          lessonId: widget.student.lessonId,
          parentPhone: parentPhoneController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تعديل بيانات الطالب")),
      body: BlocListener<StudentsCubit, StudentsState>(
        listener: (context, state) {
          if (state is StudentsLoading) {
            showDialog(
                context: context,
                builder: (context) {
                  return Center(child: CircularProgressIndicator());
                });
          }
          if (state is UpdateStudentSuccess) {
            Navigator.pop(context);
            Navigator.pop(context);
            // يقفل اللودينج } Navigator.pop(context); // يرجع من صفحة الإضافة }
          }
          if (state is StudentsFailure) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('خطأ'),
                content: Text(state.message),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: parentPhoneController,
                  labelText: 'رقم ولي الأمر',
                  hintText: 'أدخل رقم ولي الأمر',
                  onChanged: (value) {},
                ),
                if (widget.student.image != null)
                  CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(widget.student.image!)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("المصاريف مدفوعة:"),
                    Checkbox(
                        value: feesPayed,
                        onChanged: (v) {
                          setState(() {
                            feesPayed = v!;
                          });
                        }),
                  ],
                ),
                ElevatedButton(
                  onPressed: submit,
                  child: const Text('حفظ التعديلات'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
