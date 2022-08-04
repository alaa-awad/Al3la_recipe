import 'dart:io';
import 'package:al3la_recipe/features/category/presentation/cubit/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/strings/map_failure_to_message.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/add_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../domain/usecases/get_all_category_usecase.dart';
import '../../domain/usecases/get_category_image_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(
      {required this.getAllCategories,
      required this.addCategory,
      required this.deleteCategory,
      required this.updateCategory,
      required this.getCategoryImage})
      : super(CategoryInitState());

  static CategoryCubit get(context) => BlocProvider.of(context);
  final GetAllCategoryUseCase getAllCategories;
  final AddCategoryUseCase addCategory;
  final DeleteCategoryUseCase deleteCategory;
  final UpdateCategoryUseCase updateCategory;
  final GetCategoryImageUseCase getCategoryImage;

  void getCategoryImageCubit({source = ImageSource.gallery}) async {
    final failureOrCategories =
        await getCategoryImage(source: ImageSource.gallery);
    failureOrCategories.fold((l) => emit(CategoryImagePickedErrorState()),
        (r) => emit(CategoryImagePickedSuccessState()));
  }

  //function to get category from firebase

  void getCategoryCubit() async {
    emit(GetCategoryLoadingStates());
    final failureOrCategories = await getAllCategories();
    failureOrCategories.fold(
        (failure) => emit(GetCategoryErrorStates(mapFailureToMessage(failure))),
        (myCategories) {
      emit(GetCategorySuccessStates(myCategories));
    });
  }

  void addCategoryCubit({
    required String name,
  }) async {
    emit(AddCategoryLoadingStates());
    final failureOrDoneMessage = await addCategory(name: name);
    failureOrDoneMessage.fold(
        (failure) => emit(AddCategoryErrorStates(mapFailureToMessage(failure))),
        (r) => emit(AddCategorySuccessStates()));
    getCategoryCubit();
  }

  void updateCategoryCubit({
    required Category category,
  }) async {
    emit(UpdateCategoryLoadingStates());
    final failureOrDoneMessage = await updateCategory(category: category);
    failureOrDoneMessage.fold(
        (failure) =>
            emit(UpdateCategoryErrorStates(mapFailureToMessage(failure))),
        (r) => emit(UpdateCategorySuccessStates()));
    getCategoryCubit();
  }

  // function delete meal
  void deleteCategoryCubit({
    required String idCategory,
  }) async {
    emit(DeleteCategoryLoadingStates());
    final failureOrDoneMessage = await deleteCategory(idCategory: idCategory);
    failureOrDoneMessage.fold(
        (failure) =>
            emit(DeleteCategoryErrorStates(mapFailureToMessage(failure))),
        (r) => emit(DeleteCategorySuccessStates()));
    getCategoryCubit();
  }
}
