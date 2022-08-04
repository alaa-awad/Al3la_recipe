import 'package:al3la_recipe/features/meal/domain/repositories/meal_repositories.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failures.dart';

class GetImageMealUseCase {
  final MealRepositories repositories;

  GetImageMealUseCase(this.repositories);

  Future<Either<Failure, Unit>> call(
      {source = ImageSource.gallery}) async {
    return await repositories.getMealImage(source: source);
  }
}
