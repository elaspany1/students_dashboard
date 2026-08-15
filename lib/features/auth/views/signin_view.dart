import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/core/constants/theme/app_colors.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/core/widgets/custom_button.dart';
import 'package:my_teacher/features/home/prsrentation/cubits/sections_cubit/sections_cubit.dart';
import 'package:my_teacher/features/home/prsrentation/views/home_view.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomButton(
            text: 'login',
            color: AppColors.secondary,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                return BlocProvider<SectionsCubit>(
                  create: (context) {
                    return getIt<SectionsCubit>();
                  },
                  child: HomeView(),
                );
              }));
            }),
      ),
    );
  }
}
