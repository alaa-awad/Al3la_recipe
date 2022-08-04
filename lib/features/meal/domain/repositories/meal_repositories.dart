import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failures.dart';
import '../entities/meal.dart';

abstract class MealRepositories {
  Future<Either<Failure, List<Meal>>> getAllMeals({required String idCategory});
  Future<Either<Failure, Unit>> addMeal(
      {required Meal meal, required String uIdCategory});
  Future<Either<Failure, Unit>> updateMeal(
      {required Meal meal, required String uIdCategory});
  Future<Either<Failure, Unit>> deleteMeal(
      {required String idMeal, required String uIdCategory});
  Future<Either<Failure, Unit>> getMealImage({source = ImageSource.gallery});
}
