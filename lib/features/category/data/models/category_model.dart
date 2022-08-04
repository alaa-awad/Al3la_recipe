import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({required super.uId, required super.name, super.image});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        uId: json['uId'], name: json['name'], image: json["image"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'name': name,
      "image": image,
    };
  }
}
