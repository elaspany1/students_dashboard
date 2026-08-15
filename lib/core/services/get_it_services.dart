import 'package:get_it/get_it.dart';
import 'package:my_teacher/core/services/answers_services.dart';
import 'package:my_teacher/core/services/answers_storage_service.dart';
import 'package:my_teacher/core/services/exams_service.dart';
import 'package:my_teacher/core/services/lessons_services.dart';
import 'package:my_teacher/core/services/questins_storage_services.dart';
import 'package:my_teacher/core/services/question_services.dart';
import 'package:my_teacher/core/services/student_storage_service.dart';
import 'package:my_teacher/core/services/students_services.dart';
import 'package:my_teacher/features/answers/data/answers_servise_impl.dart';
import 'package:my_teacher/features/answers/data/answers_supabase_storage_service.dart';
import 'package:my_teacher/features/answers/domain/repos/answers_repo.dart';
import 'package:my_teacher/features/answers/presentation/answers_cubit/answers_cubit.dart';
import 'package:my_teacher/features/exams/data/exams_service_impl.dart';
import 'package:my_teacher/features/exams/presentation/cubits/lesson_cubit/exams_cubit.dart';
import 'package:my_teacher/features/exams/presentation/domain/repos/exams_repo.dart';
import 'package:my_teacher/features/questions/data/models/questions_supabase_storage_service.dart';
import 'package:my_teacher/core/services/section_service.dart';
import 'package:my_teacher/features/home/domain/repos/section_repo.dart';
import 'package:my_teacher/features/home/prsrentation/cubits/sections_cubit/sections_cubit.dart';
import 'package:my_teacher/features/home/data/section_service_imp.dart';
import 'package:my_teacher/features/lessons/data/lesson_service_impl.dart';
import 'package:my_teacher/features/lessons/presentation/cubits/lesson_cubit/lesson_cubit.dart';
import 'package:my_teacher/features/lessons/presentation/domain/repos/lesson_repo.dart';
import 'package:my_teacher/features/questions/data/question_servise_impl.dart';
import 'package:my_teacher/features/questions/domain/repos/question_repo.dart';
import 'package:my_teacher/features/questions/presentation/question_cubit/question_cubit.dart';
import 'package:my_teacher/features/students/data/student_servise_impl.dart';
import 'package:my_teacher/features/students/data/student_supabase_storage_service.dart';
import 'package:my_teacher/features/students/domain/repos/students_repo.dart';
import 'package:my_teacher/features/students/presentation/student_cubit/student_cubit.dart';

GetIt getIt = GetIt.instance;

initGitIt() {
  ///classes
  getIt.registerSingleton<SectionService>(SectionServiceImp());
  getIt.registerSingleton<SectionRepo>(
      SectionRepo(service: getIt<SectionService>()));
  getIt.registerFactory<SectionsCubit>(
      () => SectionsCubit(getIt<SectionRepo>()));
///////////////////////////

  ///lessons
  getIt.registerSingleton<LessonService>(LessonServiceImpl());
  getIt.registerSingleton<LessonRepo>(
      LessonRepo(service: getIt<LessonService>()));
  getIt.registerFactory<LessonCubit>(
    () => LessonCubit(service: getIt<LessonRepo>()),
  );
//////////////////////////////////////////

//questions
  getIt.registerSingleton<QuestinsStorageServices>(SupabaseStorageServices());
  ///////
  getIt.registerSingleton<QuestionServices>(QuestionServiseImpl(
      questinsStorageServices: getIt<QuestinsStorageServices>()));
  ////////////
  getIt.registerSingleton<QuestionRepo>(
      QuestionRepo(questionServices: getIt<QuestionServices>()));
  //////////////
  getIt.registerFactory<QuestionsCubit>(
      () => QuestionsCubit(questionRepo: getIt<QuestionRepo>()));
  //////////////////////////////////////////////////////////////

  //students
  getIt.registerSingleton<StudentStorageService>(
      StudentSupabaseStorageService());
  ///////
  getIt.registerSingleton<StudentsServices>(
      StudentServiseImp(studentStorageService: getIt<StudentStorageService>()));
  ////////////
  getIt.registerSingleton<StudentRepo>(
      StudentRepo(studentsServices: getIt<StudentsServices>()));
  //////////////
  getIt.registerFactory<StudentsCubit>(
      () => StudentsCubit(studentsRepo: getIt<StudentRepo>()));
  //////////////////////////////////////////////////////////////

  //answers
  getIt.registerSingleton<AnswersStorageService>(
      AnswersSupabaseStorageService());
  ///////
  getIt.registerSingleton<AnswersServices>(AnswersServiseImpl(
      answersStorageService: getIt<AnswersStorageService>()));
  ////////////
  getIt.registerSingleton<AnswersRepo>(
      AnswersRepo(answersServices: getIt<AnswersServices>()));
  //////////////
  getIt.registerFactory<AnswersCubit>(
      () => AnswersCubit(answersRepo: getIt<AnswersRepo>()));
  ////////////////////////////////////////////

  ///////exams
  getIt.registerSingleton<ExamsService>(ExamsServiceImpl());
  getIt.registerSingleton<ExamsRepo>(ExamsRepo(service: getIt<ExamsService>()));
  getIt.registerFactory<ExamsCubit>(
    () => ExamsCubit(service: getIt<ExamsRepo>()),
  );
}
