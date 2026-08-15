import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/features/home/domain/enteties/section_entity.dart';
import 'package:my_teacher/features/home/domain/repos/section_repo.dart';

part 'sections_state.dart';

class SectionsCubit extends Cubit<SectionsState> {
  final SectionRepo service;

  SectionsCubit(this.service) : super(SectionsInitial());
  int _reqToken = 0;
  // ignore: unused_field
  bool _isLoading = false;
  Future<void> fetchSections() async {
    final myToken = ++_reqToken;

    if (state is! SectionsSuccess) emit(SectionsLoading());

    _isLoading = true;
    final result = await service.getAllSections(tableName: 'classes');
    if (myToken != _reqToken) return; // إسقاط النتيجة القديمة

    _isLoading = false;
    result.fold(
      (l) => emit(SectionsFailure(l.message)),
      (r) => emit(SectionsSuccess(r)),
    );
  }

  Future<void> addSection({required String name}) async {
    final result = await service.addSection(name: name, tableName: 'classes');
    result.fold(
      (l) => emit(SectionsFailure(l.message)),
      (_) => fetchSections(),
    );
  }

  Future<void> updateSection(int id, String newName) async {
    final result = await service.updateSection(
        classId: id, newName: newName, tableName: 'classes');
    result.fold(
      (l) => emit(SectionsFailure(l.message)),
      (_) => fetchSections(),
    );
  }

  Future<void> deleteSection(int id) async {
    final result =
        await service.deleteSection(classId: id, tableName: 'classes');
    result.fold(
      (l) => emit(SectionsFailure(l.message)),
      (_) => fetchSections(),
    );
  }
}
