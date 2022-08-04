import 'package:al3la_recipe/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import '../entities/category.dart';

import '../../../../core/error/failures.dart';

class UpdateCategoryUseCase{

  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<Either<Failure,Unit>> call({required Category category}) async{
    return await repository.updateCategory(category:category );
  }
}