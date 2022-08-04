import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/meal.dart';
import '../repositories/meal_repositories.dart';

class GetAllMealsUseCase {
  final MealRepositories repositories;

  GetAllMealsUseCase(this.repositories);

  Future<Either<Failure, List<Meal>>> call({required String idCategory})async{
  return  await repositories.getAllMeals(idCategory: idCategory);
  }
}