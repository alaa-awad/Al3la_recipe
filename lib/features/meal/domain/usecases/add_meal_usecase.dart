import 'package:al3la_recipe/features/meal/domain/repositories/meal_repositories.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/meal.dart';

class AddMealUseCase {
  final MealRepositories repositories;

  AddMealUseCase(this.repositories);

  Future<Either<Failure, Unit>> call(
      {required Meal meal, required String uIdCategory}) async {
    return await repositories.addMeal(meal: meal, uIdCategory: uIdCategory);
  }
}
