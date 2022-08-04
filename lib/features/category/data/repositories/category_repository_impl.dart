import 'dart:io';

import 'package:al3la_recipe/core/error/failures.dart';
import 'package:al3la_recipe/core/network/network_info.dart';
import 'package:al3la_recipe/features/category/data/datasources/local_data_source.dart';
import 'package:al3la_recipe/features/category/data/datasources/remote_data_source.dart';
import 'package:al3la_recipe/features/category/data/models/category_model.dart';
import 'package:al3la_recipe/features/category/domain/entities/category.dart';
import 'package:al3la_recipe/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/var.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCategories = await remoteDataSource.getAllCategories();
        return Right(remoteCategories);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addCategory({required String name}) async {
    return await _getMessage(() => remoteDataSource.addCategory(name: name));
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(
      {required String idCategory}) async {
    return await _getMessage(
        () => remoteDataSource.deleteCategory(idCategory: idCategory));
  }

  @override
  Future<Either<Failure, Unit>> updateCategory(
      {required Category category}) async {
    CategoryModel categoryModel = CategoryModel(
        uId: category.uId, name: category.name, image: category.image);
    return await _getMessage(
        () => remoteDataSource.updateCategory(categoryModel: categoryModel));
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> getCategoryImage(
      {source = ImageSource.gallery}) async {
    try {
      await localDataSource.getCategoryImage(source: ImageSource.gallery);
      return const Right(unit);
    } on ImagePickerException {
      return Left(ImagePickerFailure());
    }
  }
}
