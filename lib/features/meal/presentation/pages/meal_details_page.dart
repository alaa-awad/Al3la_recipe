import 'dart:io';
import 'package:al3la_recipe/core/localization/get_os.dart';
import 'package:al3la_recipe/core/routing/navigate_and_finish.dart';
import 'package:al3la_recipe/core/var.dart';
import 'package:al3la_recipe/features/meal/presentation/cubit/meal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/localization/get_translate.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widget/adaptive/adaptive_text_field.dart';
import '../../../../core/widget/loading_page.dart';
import '../../../category/domain/entities/category.dart';
import '../../domain/entities/meal.dart';
import '../cubit/meal_state.dart';
import 'meals_page.dart';

final mealDetailsPageFormKey = GlobalKey<FormState>();

class MealDetailsPage extends StatelessWidget {
  final Meal? meal;
  final Category category;
  late bool canUpdate;


  MealDetailsPage(
      {Key? key, this.meal, required this.category, required this.canUpdate})
      : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController describeController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (meal != null) {
      nameController.text = meal?.name ?? "";
      describeController.text = meal?.describe ?? "";
      ingredientsController.text = meal?.ingredients ?? "";
      noteController.text = meal?.note ?? "";

      nameController.selection = TextSelection.fromPosition(
          TextPosition(offset: nameController.text.length));
      describeController.selection = TextSelection.fromPosition(
          TextPosition(offset: describeController.text.length));
      ingredientsController.selection = TextSelection.fromPosition(
          TextPosition(offset: ingredientsController.text.length));
      noteController.selection = TextSelection.fromPosition(
          TextPosition(offset: noteController.text.length));
    }
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<MealCubit, MealState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: _appBar(context, meal, category),
            body: _child(context),
          );
        });
  }

  Widget _child(BuildContext context) {
    return BlocConsumer<MealCubit, MealState>(
      listener: (context, state) async {
        if (state is AddMealSuccessStates || state is UpdateMealSuccessStates) {
          MealCubit.get(context).getMealsCubit(idCategory: category.uId);
        }
        if (state is GetMealSuccessStates) {
          //  navigateAndFinish(context, MealsPage(category: category));
          navigatePushAndReplacement(context, MealsPage(category: category));
        }
        if (state is UpdateMealErrorStates) {
          SnackBarMessage()
              .showErrorSnackBar(message: state.error, context: context);
        }
        if (state is AddMealErrorStates) {
          SnackBarMessage()
              .showErrorSnackBar(message: state.error, context: context);
        }
      },
      builder: (context, state) {
        if (state is AddMealLoadingStates || state is UpdateMealLoadingStates) {
          return loadingPage();
        }
        return SingleChildScrollView(
          child: Form(
            key: mealDetailsPageFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Image(
                        image: (mealImage == null)
                            ? (meal?.image != null)
                                ? NetworkImage("${meal?.image}")
                                : const AssetImage("assets/images/addPhoto.jpg")
                                    as ImageProvider
                            : FileImage(mealImage as File),
                        fit: BoxFit.cover,
                      ),
                    ),
                    IconButton(
                      icon: const CircleAvatar(
                          radius: 20,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 18,
                          )),
                      onPressed: () {
                        MealCubit.get(context).getMealImageCubit();
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.fastfood_outlined,
                        color: defaultColor,
                        size: 27,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context,
                            'add_meal_page_body_text_filed_add_name_label'),
                        style: const TextStyle(
                            color: defaultColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AdaptiveTextField(
                    os: getOs(),
                    isClickable: canUpdate,
                    /*   label: getTranslated(
                        context, 'add_meal_page_body_text_filed_add_name_label'),*/
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context,
                            'add_meal_page_body_text_filed_add_name_validate_isEmpty');
                      }
                    },
                    // prefix: Icons.fastfood_outlined,
                    //textInputAction: TextInputAction.done,
                    inputBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    boxDecoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: defaultColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description,
                        color: defaultColor,
                        size: 27,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        getTranslated(context,
                            'add_meal_page_body_text_filed_add_ingredients_label'),
                        style: const TextStyle(
                            color: defaultColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AdaptiveTextField(
                    os: getOs(),
                    maxLine: 10,
                    isClickable: canUpdate,
                    controller: ingredientsController,
                    type: TextInputType.multiline,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context,
                            'add_meal_page_body_text_filed_add_ingredients_validate_isEmpty');
                      }
                    },
                    inputBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    boxDecoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: defaultColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description,
                        color: defaultColor,
                        size: 27,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context,
                            'add_meal_page_body_text_filed_add_describe_label'),
                        style: const TextStyle(
                            color: defaultColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AdaptiveTextField(
                    os: getOs(),
                    maxLine: 10,
                    isClickable: canUpdate,
                    controller: describeController,
                    type: TextInputType.multiline,
                    inputBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    boxDecoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: defaultColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description,
                        color: defaultColor,
                        size: 27,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context,
                            'add_meal_page_body_text_filed_add_note_label'),
                        style: const TextStyle(
                            color: defaultColor,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AdaptiveTextField(
                    os: getOs(),
                    // isExpanded: true,
                    maxLine: 10,
                    isClickable: canUpdate,
                    /*    label: getTranslated(
                          context, 'add_meal_page_body_text_filed_add_note_label'),*/
                    controller: noteController,
                    type: TextInputType.multiline,
                    // prefix: Icons.description,
                    //textInputAction: TextInputAction.done,
                    inputBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    boxDecoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: defaultColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  dynamic _appBar(BuildContext context, Meal? meal, Category category) {
    return AppBar(
      /*  leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          navigateAndFinish(context, MealsPage(category: category));
        },
      ),*/
      actions: [
        IconButton(
            onPressed: () {
              canUpdate = !canUpdate;
              MealCubit.get(context).emit(ChangeUpdateState());
            },
            icon: Icon(
              canUpdate ? Icons.lock_open : Icons.lock,
              color: defaultColor,
            )),
        const SizedBox(
          width: 7,
        ),
        TextButton(
            onPressed: () {
              (meal != null)
                  ? _updateMeal(
                      category: category, meal: meal, context: context)
                  : _addNewMeal(category: category, context: context);
            },
            child: (meal != null)
                ? Text(getTranslated(
                    context, "Page_meal_details_textButton_update"))
                : Text(getTranslated(
                    context, "Page_meal_details_textButton_save"))),
      ],
    );
  }

  _addNewMeal({required BuildContext context, required Category category}) {
    if (mealDetailsPageFormKey.currentState!.validate()) {
      Meal newMeal = Meal(
        uId: "",
        name: nameController.text,
        ingredients: ingredientsController.text,
        note: noteController.text.isEmpty ? null : noteController.text,
        describe:
            describeController.text.isEmpty ? null : describeController.text,
      );
      MealCubit.get(context)
          .addMealCubit(meal: newMeal, uIdCategory: category.uId);
      /*   navigateAndFinish(
          context,
          MealsPage(
            category: category,
          ));*/
    }
  }

  _updateMeal({
    required Category category,
    required Meal meal,
    required BuildContext context,
  }) {
    if (mealDetailsPageFormKey.currentState!.validate()) {
      Meal updateMeal = Meal(
        uId: meal.uId,
        name: nameController.text,
        ingredients: ingredientsController.text,
        note: noteController.text.isEmpty ? null : noteController.text,
        describe:
            describeController.text.isEmpty ? null : describeController.text,
        image: meal.image,
      );
      MealCubit.get(context)
          .updateMealCubit(meal: updateMeal, uIdCategory: category.uId);

      /* navigateAndFinish(
          context,
          MealsPage(
            category: category,
          ));*/
    }
  }
}
