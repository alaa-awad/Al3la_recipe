import 'package:al3la_recipe/features/meal/domain/entities/meal.dart';

class MealModel extends Meal {
  const MealModel(
      {required super.uId,
      required super.name,
      required super.ingredients,
      super.note,
      super.image,
      super.describe});

  factory MealModel.fromJson(dynamic json) {
    return MealModel(
        uId: json["uId"],
        name: json["name"],
        ingredients: json["ingredients"],
        note: json["note"],
        image: json["image"],
        describe: json["describe"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'name': name,
      'describe': describe,
      'ingredients': ingredients,
      'image': image,
      'note': note,
    };
  }
}
