import 'package:al3la_recipe/features/meal/presentation/cubit/meal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/localization/get_translate.dart';
import '../../../../core/routing/navigate_to.dart';
import '../../../../core/var.dart';
import '../../../../core/widget/show_dialog_delete.dart';
import '../../../category/domain/entities/category.dart';
import '../../domain/entities/meal.dart';
import '../pages/meal_details_page.dart';

Widget itemMeal(
    {required BuildContext context,
    required Meal meal,
    required Category category}) {
  return Slidable(
    startActionPane:
        deleteActionPane(context: context, category: category, meal: meal),
    // endActionPane: editActionPane(context: context),
    child: _child(context, meal,category),
  );
}

Widget _child(BuildContext context, Meal meal,Category category) {
  return InkWell(
    onTap: () {
      mealImage = null;
      navigateTo(context, MealDetailsPage(meal: meal, category: category,canUpdate: false,));
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: meal.image == null
                  ? const AssetImage('assets/images/addPhoto.jpg')
                  : NetworkImage(meal.image!) as ImageProvider,
              radius: 30,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  meal.name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

ActionPane deleteActionPane(
    {required BuildContext context,
    required Category category,
    required Meal meal}) {
  return ActionPane(motion: const ScrollMotion(), children: [
    SlidableAction(
      onPressed: (_) {
        showDialogDelete(
            context: context,
            function: () {
              MealCubit.get(context)
                  .deleteMealCubit(idCategory: category.uId, idMeal: meal.uId);
            },
            btnOkText: getTranslated(context, "showDialog_OK_title"),
            btnCancelText: getTranslated(context, "showDialog_Cancel_title"),
            title: meal.name,
            describe: getTranslated(
                context, 'add_meal_page_body_button_delete_meal'));
      },
      backgroundColor: Colors.redAccent,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: getTranslated(context, "category_page_body_deleteActionPane"),
      borderRadius: BorderRadius.circular(20),
    ),
  ]);
}
