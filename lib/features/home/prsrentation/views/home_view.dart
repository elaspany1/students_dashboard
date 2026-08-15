import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/widgets/dialogs/section_dialog.dart';
import 'package:my_teacher/features/home/prsrentation/cubits/sections_cubit/sections_cubit.dart';
import 'package:my_teacher/features/home/prsrentation/views/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الأقسام")),
      body: HomeViewBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (c) {
                return SectionDialog(
                  confirmText: 'تأكيد',
                  controller: controller,
                  title: 'اضافة قسم جديد',
                  onConfirm: (value) {
                    BlocProvider.of<SectionsCubit>(context)
                        .addSection(name: value);
                    Navigator.pop(context);
                  },
                );
              });
        },
      ),
    );
  }
}
