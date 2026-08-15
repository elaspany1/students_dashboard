import 'package:my_teacher/features/home/domain/enteties/section_entity.dart';

abstract class SectionService {
  Future<void> addSection({required String name, required String tableName});
  Future<void> deleteSection({required int classId, required String tableName});
  Future<void> updateSection(
      {required int classId,
      required String newName,
      required String tableName});
  Future<List<SectionEntity>> getAllSections({required String tableName});
}
