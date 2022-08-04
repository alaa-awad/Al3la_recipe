import 'package:al3la_recipe/features/meal/presentation/cubit/meal_cubit.dart';
import 'package:al3la_recipe/features/meal/presentation/pages/meals_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../core/widget/show_dialog_delete.dart';
import '../../../../core/localization/get_translate.dart';
import '../../../../core/routing/navigate_to.dart';
import '../../domain/entities/category.dart';
import '../cubit/category_cubit.dart';
import 'add_or_update_category_dialog.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  const CategoryItem({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Slidable(
        startActionPane: deleteActionPane(context: context),
        endActionPane: editActionPane(context: context),
        child: _child(context),
      ),
    );
  }

  Widget _child(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                    onTap: () {
                      ///ToDo: add page to navigate
                      //print("category item name is ${category.name}\ncategory item id is ${category.uId},");
                      MealCubit.get(context).getMealsCubit(idCategory: category.uId);
                      navigateTo(context,MealsPage(category: category));
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: category.image != null
                                  ? NetworkImage(category.image!)
                                  : const AssetImage(
                                          "assets/images/addPhoto.jpg")
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ActionPane deleteActionPane({required BuildContext context}) {
    return ActionPane(motion: const ScrollMotion(), children: [
      SlidableAction(
        onPressed: (_) {
          showDialogDelete(
              context: context,
              title: category.name,
              describe: getTranslated(
                  context, "category_page_body_showDialogDelete_dec"),
              function: () {
                /*BlocProvider.of<CategoryBloc>(context).add(
                  DeleteCategoryEvent(category.uId),
                );*/
                CategoryCubit.get(context).deleteCategoryCubit(
                  idCategory: category.uId,
                );
              });
        },
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: getTranslated(context, "category_page_body_deleteActionPane"),
        borderRadius: BorderRadius.circular(20),
      ),
    ]);
  }

  ActionPane editActionPane({required BuildContext context}) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          // An action can be bigger than the others.
          flex: 1,
          onPressed: (_) {
            // AddCubit.get(context).mealImage = null;
            addOrUpdateCategoryDialog(context: context, category: category);
          },
          backgroundColor: const Color(0xFF7BC043),
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: getTranslated(context, "category_page_body_editActionPane"),
          borderRadius: BorderRadius.circular(20),
        )
      ],
    );
  }
}
