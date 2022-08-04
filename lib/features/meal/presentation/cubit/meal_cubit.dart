import 'package:al3la_recipe/features/meal/domain/usecases/add_meal_usecase.dart';
import 'package:al3la_recipe/features/meal/domain/usecases/delete_meal_usecase.dart';
import 'package:al3la_recipe/features/meal/domain/usecases/update_meal_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/strings/map_failure_to_message.dart';
import '../../domain/entities/meal.dart';
import '../../domain/usecases/get_all_meals_usecase.dart';
import '../../domain/usecases/get_meal_image_usecase.dart';
import 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  MealCubit(
      {required this.getAllMeals,
      required this.addMeal,
      required this.updateMeal,
      required this.deleteMeal,
      required this.getMealImage})
      : super(MealInitState());

  static MealCubit get(context) => BlocProvider.of(context);

  final GetAllMealsUseCase getAllMeals;
  final AddMealUseCase addMeal;
  final UpdateMealUseCase updateMeal;
  final DeleteMealUseCase deleteMeal;
  final GetImageMealUseCase getMealImage;

  void getMealImageCubit({source = ImageSource.gallery}) async {
    final failureOrCategories = await getMealImage(source: source);
    failureOrCategories.fold((l) => emit(MealImagePickedErrorState()),
        (r) => emit(MealImagePickedSuccessState()));
  }

  //function to get category from firebase
  List<Meal> meals = [];
  void getMealsCubit({required String idCategory}) async {
    meals = [];
    emit(GetMealLoadingStates());
    final failureOrCategories = await getAllMeals(idCategory: idCategory);
    failureOrCategories.fold(
        (failure) => emit(GetMealErrorStates(mapFailureToMessage(failure))),
        (myMeals) {
      meals = myMeals;
      emit(GetMealSuccessStates(myMeals));
    });
  }

  void addMealCubit({
    required Meal meal,
    required String uIdCategory,
  }) async {
    emit(AddMealLoadingStates());
    final failureOrDoneMessage =
        await addMeal(meal: meal, uIdCategory: uIdCategory);
    failureOrDoneMessage.fold(
        (failure) => emit(AddMealErrorStates(mapFailureToMessage(failure))),
        (r) => emit(AddMealSuccessStates()));

  }

  void updateMealCubit({
    required Meal meal,
    required String uIdCategory,
  }) async {
    emit(UpdateMealLoadingStates());
    final failureOrDoneMessage =
        await updateMeal(meal: meal, uIdCategory: uIdCategory);
    failureOrDoneMessage.fold(
        (failure) => emit(UpdateMealErrorStates(mapFailureToMessage(failure))),
        (r) => emit(UpdateMealSuccessStates()));
    getMealsCubit(idCategory: uIdCategory);
  }

  // function delete meal
  void deleteMealCubit({
    required String idCategory,
    required String idMeal,
  }) async {
    emit(DeleteMealLoadingStates());
    final failureOrDoneMessage =
        await deleteMeal(uIdCategory: idCategory, idMeal: idMeal);
    failureOrDoneMessage.fold(
        (failure) => emit(DeleteMealErrorStates(mapFailureToMessage(failure))),
        (r) => emit(DeleteMealSuccessStates()));
    getMealsCubit(idCategory: idCategory);
  }

}
