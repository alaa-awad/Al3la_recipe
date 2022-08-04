import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/localization/get_os.dart';
import '../../../../../core/localization/get_translate.dart';
import '../../../../../core/var.dart';
import '../../../../../core/widget/adaptive/adaptive_button.dart';
import '../../../../../core/widget/adaptive/adaptive_text_field.dart';
import '../../domain/entities/category.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';

dynamic addOrUpdateCategoryDialog({
  required BuildContext context,
  Category? category,
}) {
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> addCategoryFormKey = GlobalKey<FormState>();
  categoryImage = null;
  return AwesomeDialog(
    context: context,
    dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
    width: MediaQuery.of(context).size.width * 0.9,
    animType: AnimType.SCALE,
    dialogType: DialogType.NO_HEADER,
    buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
    body: BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (category != null) {
          nameController.text = category.name;
        }
        return SingleChildScrollView(
          child: Form(
            key: addCategoryFormKey,
            child: Column(children: [
              const SizedBox(
                height: 15,
              ),
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  CircleAvatar(
                    backgroundImage: categoryImage == null
                        ? category == null || category.image == null
                            ? const AssetImage('assets/images/addPhoto.jpg')
                                as ImageProvider
                            : NetworkImage(category.image!)
                        : FileImage(categoryImage as File),
                    radius: 70,
                  ),
                  IconButton(
                    icon: const CircleAvatar(
                        radius: 20,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 18,
                        )),
                    onPressed: () {
                      CategoryCubit.get(context).getCategoryImageCubit();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AdaptiveTextField(
                  label: getTranslated(context,
                      'add_category_page_body_text_filed_add_name_label'),
                  controller: nameController,
                  os: getOs(),
                  validate: (value) {
                    if (value!.isEmpty) {
                      return getTranslated(context,
                          'add_category_page_body_text_filed_add_name_validate_isEmpty');
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              category != null
                  ? AdaptiveButton(
                      os: getOs(),
                      function: () {
                        if (addCategoryFormKey.currentState!.validate()) {
                          Category categoryUpdated = Category(
                              name: nameController.text,
                              uId: category.uId,
                              image: category.image);
                          /*   CategoryBloc.get(context)
                              .add(UpdateCategoryEvent(categoryUpdated));
                       */
                          CategoryCubit.get(context).updateCategoryCubit(
                            category: categoryUpdated,
                          );
                          Navigator.pop(context);
                        }
                      },
                      text: getTranslated(context,
                          'add_category_page_body_button_update_category'))
                  : AdaptiveButton(
                      os: getOs(),
                      function: () {
                        if (addCategoryFormKey.currentState!.validate()) {
                          /*   CategoryBloc.get(context)
                              .add(AddCategoryEvent(nameController.text));
*/
                          CategoryCubit.get(context).addCategoryCubit(
                            name: nameController.text,
                          );
                          Navigator.pop(context);
                        }
                      },
                      text: getTranslated(context,
                          'add_category_page_body_button_add_category')),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
        );
      },
    ),
  ).show();
}
