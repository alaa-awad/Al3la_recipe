import 'package:al3la_recipe/features/category/data/repositories/category_repository_impl.dart';
import 'package:al3la_recipe/features/category/domain/repositories/category_repository.dart';
import 'package:al3la_recipe/features/category/domain/usecases/add_category_usecase.dart';
import 'package:al3la_recipe/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:al3la_recipe/features/category/domain/usecases/get_all_category_usecase.dart';
import 'package:al3la_recipe/features/category/domain/usecases/get_category_image_usecase.dart';
import 'package:al3la_recipe/features/category/domain/usecases/update_category_usecase.dart';
import 'package:al3la_recipe/features/category/presentation/cubit/category_cubit.dart';
import 'package:al3la_recipe/features/meal/data/repositories/meal_repositories_impl.dart';
import 'package:al3la_recipe/features/meal/domain/repositories/meal_repositories.dart';
import 'package:al3la_recipe/features/meal/domain/usecases/add_meal_usecase.dart';
import 'package:al3la_recipe/features/meal/domain/usecases/get_all_meals_usecase.dart';
import 'package:al3la_recipe/features/meal/domain/usecases/get_meal_image_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/data/datasources/user_local_data_source.dart';
import '../features/auth/data/datasources/user_remote_data_source.dart';
import '../features/auth/data/repositories/user_repository_impl.dart';
import '../features/auth/domain/repositories/user_repository.dart';
import '../features/auth/domain/usecases/log_in_usecase.dart';
import '../features/auth/domain/usecases/sign_up_usecase.dart';
import '../features/auth/presentation/cubit/user_cubit.dart';
import '../features/category/data/datasources/local_data_source.dart';
import '../features/category/data/datasources/remote_data_source.dart';
import '../features/meal/data/datasources/meal_local_data_source.dart';
import '../features/meal/data/datasources/meal_remote_data_source.dart';
import '../features/meal/domain/usecases/delete_meal_usecase.dart';
import '../features/meal/domain/usecases/update_meal_usecase.dart';
import '../features/meal/presentation/cubit/meal_cubit.dart';
import 'network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
//! Features - posts

// Bloc

  /* sl.registerFactory(() => CategoryBloc(
        getAllCategories: sl(),
        addCategory: sl(),
        updateCategory: sl(),
        deleteCategory: sl(),
        getCategoryImage: sl(),
      ));*/
// cubit category
  sl.registerFactory(() => CategoryCubit(
        getAllCategories: sl(),
        addCategory: sl(),
        updateCategory: sl(),
        deleteCategory: sl(),
        getCategoryImage: sl(),
      ));
// cubit meal
  sl.registerFactory(() => MealCubit(
        getAllMeals: sl(),
        addMeal: sl(),
        updateMeal: sl(),
        deleteMeal: sl(),
        getMealImage: sl(),
      ));

  // cubit user
  sl.registerFactory(() => UserCubit(logIn: sl(), signUp: sl()));

  // UseCase category
  sl.registerLazySingleton(() => GetAllCategoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddCategoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCategoryUseCase(sl()));
  sl.registerLazySingleton(
      () => GetCategoryImageUseCase(categoryRepository: sl()));

  // UseCase meal
  sl.registerLazySingleton(() => GetAllMealsUseCase(sl()));
  sl.registerLazySingleton(() => AddMealUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMealUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMealUseCase(sl()));
  sl.registerLazySingleton(() => GetImageMealUseCase(sl()));

  // UseCase category
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LogInUseCase(sl()));

// Repository category
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
// Repository meal
  sl.registerLazySingleton<MealRepositories>(() => MealRepositoriesImpl(
      mealRemoteDataSource: sl(),
      mealLocalDataSource: sl(),
      networkInfo: sl()));

  // Repository meal
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

// DataSources category
  sl.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceFromFirebase());
  sl.registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl());

  // DataSources meal
  sl.registerLazySingleton<MealRemoteDataSource>(
      () => MealRemoteDataSourceFromFirebase());
  sl.registerLazySingleton<MealLocalDataSource>(
      () => MealLocalDataSourceImpl());

  // DataSources user
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceFromFirebase());
  sl.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceWithDio());

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
