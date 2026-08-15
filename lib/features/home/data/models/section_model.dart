import 'package:my_teacher/features/home/domain/enteties/section_entity.dart';

class SectionModel {
  final int id;
  final String name;
  SectionModel({
    required this.id,
    required this.name,
  });
  factory SectionModel.fromJson(Map<String, dynamic> data) {
    return SectionModel(
      id: data['class_id'],
      name: data['name'],
    );
  }
  SectionEntity sectionEntityFromModel() {
    return SectionEntity(
      id: id,
      name: name,
    );
  }
}

/*ProductModel(
      {required this.id,
      required this.title,
      required this.image,
      required this.subTitle,
      required this.price,
      required this.categoryType});
  factory ProductModel.fromJson(Map<String, dynamic> data) {
    return ProductModel(
        id: data['id'],
        title: data['title'],
        image: data['image'],
        subTitle: data['sub_title'],
        price: data['price'],
        categoryType: data['category']);
  }
  ProductEntity productEntityFromModel() {
    return ProductEntity(
        id: id,
        title: title,
        image: image,
        subTitle: subTitle,
        price: price,
        categoryType: categoryType);
  }
}*/
