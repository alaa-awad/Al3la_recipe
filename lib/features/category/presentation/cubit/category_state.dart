import '../../domain/entities/category.dart';

abstract class CategoryState {}

class CategoryInitState extends CategoryState {}


class GetCategoryLoadingStates extends CategoryState {}

class GetCategorySuccessStates extends CategoryState {
  final List<Category> categories;

  GetCategorySuccessStates(this.categories);
}

class GetCategoryErrorStates extends CategoryState {
  final String error;
  GetCategoryErrorStates(this.error);
}



class AddCategoryLoadingStates extends CategoryState{}
class AddCategorySuccessStates extends CategoryState{}
class AddCategoryErrorStates extends CategoryState{
  final String error;
  AddCategoryErrorStates(this.error);
}

class UpdateCategoryLoadingStates extends CategoryState{}
class UpdateCategorySuccessStates extends CategoryState{}
class UpdateCategoryErrorStates extends CategoryState{
  final String error;
  UpdateCategoryErrorStates(this.error);
}

class CategoryImagePickedSuccessState extends CategoryState{}
class CategoryImagePickedErrorState extends CategoryState{}


class ChangeCategoryStates extends CategoryState{}

class DeleteCategoryLoadingStates extends CategoryState {}

class DeleteCategorySuccessStates extends CategoryState {}

class DeleteCategoryErrorStates extends CategoryState {
  final String error;
  DeleteCategoryErrorStates(this.error);
}
