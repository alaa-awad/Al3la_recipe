import 'package:al3la_recipe/core/localization/get_translate.dart';
import 'package:al3la_recipe/core/routing/navigate_and_finish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/dio/cache_helper.dart';
import '../../../../core/localization/get_os.dart';
import '../../../../core/strings/app_string.dart';
import '../../../../core/var.dart';
import '../../../../core/widget/adaptive/adaptive_indicator.dart';
import '../../../../core/util/message_display_widget.dart';
import '../../../../main.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';
import '../widgets/add_or_update_category_dialog.dart';
import '../widgets/category_item.dart';

bool isLoadingPage = false;
//String nameCategory = '';
GlobalKey<ScaffoldState> categoryPageKey = GlobalKey<ScaffoldState>();

class CategoriesPage extends StatelessWidget {
 const  CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    CategoryCubit.get(context).getCategoryCubit();

    return Scaffold(
      key: categoryPageKey,
      appBar: _appBar(context),
      floatingActionButton: _floatingActionButton(context),
      body: RefreshIndicator(
          onRefresh: () async {
            CategoryCubit.get(context).getCategoryCubit();
          },
          child: _body(context)),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        addOrUpdateCategoryDialog(context: context);
      },
    );
  }

  dynamic _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppString.appName,
        style: const TextStyle(color: Colors.amber),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.logout_rounded),
        onPressed: () {
          CacheHelper.removeData(key: "uId");
          home = LoginScreen();
          navigateAndFinish(context, const MyApp());
        },
      ),
    );
  }

  Widget _body(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
        listener: (context, state) {
     /* if (state is AddCategorySuccessStates) {
        CategoryCubit.get(context).getCategoryCubit();
      }*/
    }, builder: (context, state) {
      if (state is GetCategorySuccessStates) {
        state.categories.forEach((element) {
          print(
              "category state name is ${element.name} \n category state id is ${element.uId}");
        });
        return (state.categories.isEmpty)
            ? Center(
                child: Text(getTranslated(
                    context, "categories_page_categories_is_empty")))
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: state.categories.length,
                itemBuilder: (context, index) => CategoryItem(
                      category: state.categories[index],
                    ));
      } else if (state is GetCategoryErrorStates) {
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
