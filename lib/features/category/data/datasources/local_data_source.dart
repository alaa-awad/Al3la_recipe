import 'dart:io';

import 'package:al3la_recipe/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/var.dart';

abstract class CategoryLocalDataSource {
  Future<Unit> getCategoryImage({source = ImageSource.gallery});
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  @override
  Future<Unit> getCategoryImage({source = ImageSource.gallery}) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );
    if (pickedFile != null) {
      categoryImage = File(pickedFile.path);
    } else {
      throw ImagePickerException();
    }
    return Future.value(unit);
  }
}
