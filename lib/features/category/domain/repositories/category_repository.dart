import 'package:al3la_recipe/core/error/failures.dart';
import '../entities/category.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class CategoryRepository{

  Future<Either<Failure,List<Category>>> getAllCategories();
  Future<Either<Failure,Unit>> addCategory({required String name,});
  Future<Either<Failure,Unit>> updateCategory({required Category category,});
  Future<Either<Failure,Unit>> deleteCategory({required String idCategory,});
  Future<Either<Failure,Unit>> getCategoryImage({source = ImageSource.gallery});
}