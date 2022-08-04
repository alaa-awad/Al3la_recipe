import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/var.dart';

abstract class MealLocalDataSource {
  Future<Unit> getMealImage({source = ImageSource.gallery});
}

class MealLocalDataSourceImpl extends MealLocalDataSource {
  @override
  Future<Unit> getMealImage({source = ImageSource.gallery}) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );
    if (pickedFile != null) {
      mealImage = File(pickedFile.path);
    } else {
      throw ImagePickerException();
    }
    return Future.value(unit);
  }
}
