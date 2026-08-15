import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_teacher/core/constants/app_constants.dart';
import 'package:my_teacher/core/services/get_it_services.dart';
import 'package:my_teacher/features/auth/views/signin_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConstants.initSupabase();
  initGitIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SigninView(),
      ),
    );
  }
}
