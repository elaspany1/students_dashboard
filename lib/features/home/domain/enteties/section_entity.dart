import 'package:equatable/equatable.dart';

class SectionEntity extends Equatable {
  final int id;
  final String name;

  const SectionEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
