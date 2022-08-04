import 'package:al3la_recipe/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/category.dart';

class AddCategoryUseCase{

  final CategoryRepository repository;

  AddCategoryUseCase(this.repository);

  Future<Either<Failure,Unit>> call({required String name}) async{
    return await repository.addCategory(name: name);
  }
}