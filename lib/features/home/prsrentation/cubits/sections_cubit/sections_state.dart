part of 'sections_cubit.dart';

abstract class SectionsState {}

class SectionsInitial extends SectionsState {}

class SectionsLoading extends SectionsState {}

class SectionsSuccess extends SectionsState with EquatableMixin {
  final List<SectionEntity> sections;

  SectionsSuccess(this.sections);
  @override
  List<Object?> get props => [sections];
}

class SectionsFailure extends SectionsState {
  final String message;

  SectionsFailure(this.message);
}
