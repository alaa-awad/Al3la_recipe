import 'package:al3la_recipe/features/meal/domain/repositories/meal_repositories.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class DeleteMealUseCase {
  final MealRepositories repositories;

  DeleteMealUseCase(this.repositories);

  Future<Either<Failure, Unit>> call(
      {required String idMeal, required String uIdCategory}) async {
    return await repositories.deleteMeal(
        idMeal: idMeal, uIdCategory: uIdCategory);
  }
}
