import 'package:al3la_recipe/core/error/failures.dart';
import 'package:al3la_recipe/features/meal/data/datasources/meal_local_data_source.dart';
import 'package:al3la_recipe/features/meal/domain/entities/meal.dart';
import 'package:al3la_recipe/features/meal/domain/repositories/meal_repositories.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/meal_remote_data_source.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class MealRepositoriesImpl implements MealRepositories {
  final MealRemoteDataSource mealRemoteDataSource;
  final MealLocalDataSource mealLocalDataSource;
  final NetworkInfo networkInfo;

  MealRepositoriesImpl(
      {required this.mealRemoteDataSource,
      required this.mealLocalDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<Meal>>> getAllMeals(
      {required String idCategory}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCategories =
            await mealRemoteDataSource.getAllMeals(idCategory: idCategory);
        return Right(remoteCategories);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addMeal(
      {required Meal meal, required String uIdCategory}) async {
    return await _getMessage(() =>
        mealRemoteDataSource.addMeal(meal: meal, uIdCategory: uIdCategory));
  }

  @override
  Future<Either<Failure, Unit>> deleteMeal(
      {required String idMeal, required String uIdCategory}) async {
    return await _getMessage(() => mealRemoteDataSource.deleteMeal(
        idMeal: idMeal, uIdCategory: uIdCategory));
  }

  @override
  Future<Either<Failure, Unit>> getMealImage(
      {source = ImageSource.gallery}) async {
    try {
      await mealLocalDataSource.getMealImage(source: source);
      return const Right(unit);
    } on ImagePickerException {
      return Left(ImagePickerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMeal(
      {required Meal meal, required String uIdCategory}) async {
    return await _getMessage(() =>
        mealRemoteDataSource.updateMeal(meal: meal, uIdCategory: uIdCategory));
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
}
