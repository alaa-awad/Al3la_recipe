
import '../../domain/entities/meal.dart';

class MealState{}

class MealInitState extends MealState {}

class SearchStates extends MealState {}

class GetMealLoadingStates extends MealState {}

class GetMealSuccessStates extends MealState {
  final List<Meal> meals;

  GetMealSuccessStates(this.meals);
}

class GetMealErrorStates extends MealState {
  final String error;
  GetMealErrorStates(this.error);
}

// all states for meals
class AddMealLoadingStates extends MealState{}
class AddMealSuccessStates extends MealState{}
class AddMealErrorStates extends MealState{
  final String error;
  AddMealErrorStates(this.error);
}

// meal image state
class MealImagePickedSuccessState extends MealState{}
class MealImagePickedErrorState extends MealState{}

// update meal states
class UpdateMealLoadingStates extends MealState{}
class UpdateMealSuccessStates extends MealState{}
class UpdateMealErrorStates extends MealState{
  final String error;
  UpdateMealErrorStates(this.error);
}
// delete meal states

class DeleteMealLoadingStates extends MealState{}
class DeleteMealSuccessStates extends MealState{}
class DeleteMealErrorStates extends MealState{
  final String error;
  DeleteMealErrorStates(this.error);
}

class ChangeUpdateState extends MealState{}
