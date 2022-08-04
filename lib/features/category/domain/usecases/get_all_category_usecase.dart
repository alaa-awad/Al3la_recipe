import 'package:al3la_recipe/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/category.dart';

class GetAllCategoryUseCase{
  final CategoryRepository repository;

  GetAllCategoryUseCase({required this.repository});

  Future<Either<Failure,List<Category>>> call() async{
    return await repository.getAllCategories();
  }

}