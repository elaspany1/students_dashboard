import 'package:dartz/dartz.dart';
import 'package:my_teacher/core/errors/class_failure.dart';
import 'package:my_teacher/core/services/section_service.dart';
import 'package:my_teacher/features/home/domain/enteties/section_entity.dart';

class SectionRepo {
  final SectionService service;

  SectionRepo({required this.service});

  Future<Either<Failure, void>> addSection(
      {required String name, required String tableName}) async {
    try {
      await service.addSection(name: name, tableName: tableName);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteSection(
      {required int classId, required String tableName}) async {
    try {
      await service.deleteSection(classId: classId, tableName: tableName);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateSection({
    required int classId,
    required String newName,
    required String tableName,
  }) async {
    try {
      await service.updateSection(
          classId: classId, newName: newName, tableName: tableName);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<SectionEntity>>> getAllSections(
      {required String tableName}) async {
    try {
      final result = await service.getAllSections(tableName: tableName);
      return right(result);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
