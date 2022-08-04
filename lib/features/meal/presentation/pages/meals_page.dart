import 'package:al3la_recipe/core/routing/navigate_to.dart';
import 'package:al3la_recipe/core/var.dart';
import 'package:al3la_recipe/features/meal/presentation/cubit/meal_cubit.dart';
import 'package:al3la_recipe/features/meal/presentation/cubit/meal_state.dart';
import 'package:al3la_recipe/features/meal/presentation/pages/meal_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/get_os.dart';
import '../../../../core/localization/get_translate.dart';
import '../../../../core/routing/navigate_and_finish.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widget/adaptive/adaptive_indicator.dart';
import '../../../../core/widget/adaptive/adaptive_text_field.dart';
import '../../../../core/util/message_display_widget.dart';
import '../../../category/domain/entities/category.dart';
import '../../../category/presentation/pages/category_page.dart';
import '../widgets/item_meal.dart';

class MealsPage extends StatelessWidget {
  final Category category;
  MealsPage({Key? key, required this.category}) : super(key: key);

  var mealsPageFormKey = GlobalKey<FormState>();

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MealCubit.get(context).getMealsCubit(idCategory: category.uId);
    return Scaffold(
      appBar: _appBar(context),
      floatingActionButton: _floatingActionButton(context, category),
      body: RefreshIndicator(
          onRefresh: () async {
            MealCubit.get(context).getMealsCubit(idCategory: category.uId);
          },
          child: _body(context, category)),
    );
  }

  dynamic _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(category.name),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          navigateAndFinish(context, const CategoriesPage());
        },
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context, Category category) {
    return FloatingActionButton(
      onPressed: () {
        mealImage = null;
        navigateTo(
            context,
            MealDetailsPage(
              category: category,
              canUpdate: true,
            ));
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _body(BuildContext context, Category category) {
    return BlocConsumer<MealCubit, MealState>(listener: (context, state) {
      if (state is DeleteMealErrorStates) {
        SnackBarMessage()
            .showErrorSnackBar(message: state.error, context: context);
      }
      if (state is GetMealErrorStates) {
        SnackBarMessage()
            .showErrorSnackBar(message: state.error, context: context);
      }
    }, builder: (context, state) {
      if (state is GetMealSuccessStates ||
          state is SearchStates ||
          state is ChangeUpdateState) {
        return (MealCubit.get(context).meals.isEmpty)
            ? Center(
                child: Text(
                    getTranslated(context, "meals_page_categories_is_empty")))
            : SingleChildScrollView(
                child: Form(
                  key: mealsPageFormKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        AdaptiveTextField(
                          os: getOs(),
                          controller: searchController,
                          prefix: Icons.search,
                          label: getTranslated(context,
                              "add_meal_page_body_textField_search_liable"),
                          inputBorder: const OutlineInputBorder().copyWith(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(15.0))),
                          onSubmit: (_) {
                            MealCubit.get(context).emit(SearchStates());
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        searchController.text.isEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: MealCubit.get(context).meals.length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return itemMeal(
                                      context: context,
                                      category: category,
                                      meal:
                                          MealCubit.get(context).meals[index]);
                                },
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: MealCubit.get(context).meals.length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  if (MealCubit.get(context)
                                      .meals[index]
                                      .name
                                      .contains(searchController.text)) {
                                    /* print(MealCubit.get(context)
                                            .meals[index]
                                            .name);*/
                                    return itemMeal(
                                        context: context,
                                        category: category,
                                        meal: MealCubit.get(context)
                                            .meals[index]);
                                  }
                                  return Container();
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              );
      }
      if (state is GetMealErrorStates) {
        return MessageDisplayWidget(
          message: state.error,
        );
      }
      return Center(
          child: AdaptiveIndicator(
        os: getOs(),
      ));
    });
  }
}
