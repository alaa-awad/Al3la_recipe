

import 'package:al3la_recipe/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class DeleteCategoryUseCase{

  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<Either<Failure,Unit>> call({required String idCategory}) async{
    return await repository.deleteCategory(idCategory: idCategory);
  }
}