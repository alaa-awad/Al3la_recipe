import 'dart:io';
import 'package:al3la_recipe/core/strings/app_string.dart';
import 'package:al3la_recipe/features/category/data/models/category_model.dart';
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../../core/var.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<Unit> addCategory({
    required String name,
  });
  Future<Unit> updateCategory({
    required CategoryModel categoryModel,
  });
  Future<Unit> deleteCategory({
    required String idCategory,
  });
}

class CategoryRemoteDataSourceFromFirebase implements CategoryRemoteDataSource {
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    List<CategoryModel> category = [];
    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppString.userToken)
        .collection('Food Recipe')
        .get()
        .then((value) {
      for (var element in value.docs) {
        category.add(CategoryModel.fromJson(element.data()));
      }
      //categoryList = category;
    }).catchError((error) {
      print("Error get all Category is ${error.toString()}");
      throw ServerException();
    });

    return category;
  }

  @override
  Future<Unit> addCategory({required String name}) async {
    if (categoryImage != null) {
      await uploadImageToFirebase().then((value) async {
        await value.ref.getDownloadURL().then((value) async{
          CategoryModel categoryModel =
              CategoryModel(name: name, image: value, uId: '');
         await _addCategoryToFirebase(
            categoryModel: categoryModel,
          );
        }).catchError((error) {
          print('error getDownloadURL ${error.toString()}');
        });
      }).catchError((error) {
        print('error putFile ${error.toString()}');
      });
    } else {
      CategoryModel categoryModel =
          CategoryModel(name: name, image: null, uId: '');
     await _addCategoryToFirebase(
        categoryModel: categoryModel,
      );
    }
    return Future.value(unit);
  }

  @override
  Future<Unit> deleteCategory({required String idCategory}) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppString.userToken)
        .collection('Food Recipe')
        .doc(idCategory)
        .delete()
        .then((value) {
      getAllCategories();
      print('delete category done');
    }).catchError((error) {
      print("Error delete category is ${error.toString()}");
      throw ServerException();
    });
    return Future.value(unit);
  }

  @override
  Future<Unit> updateCategory({required CategoryModel categoryModel}) async {
    if (categoryImage != null) {
      await uploadImageToFirebase().then((value) async {
        await value.ref.getDownloadURL().then((value) {
          CategoryModel category = CategoryModel(
              name: categoryModel.name, image: value, uId: categoryModel.uId);
          _updateCategory(categoryModel: category);
        }).catchError((error) {
          print('error getDownloadURL ${error.toString()}');
        });
      }).catchError((error) {
        print('error putFile ${error.toString()}');
      });
    } else {
      CategoryModel category = CategoryModel(
          name: categoryModel.name,
          image: categoryModel.image,
          uId: categoryModel.uId);
      _updateCategory(
        categoryModel: category,
      );
    }
    return Future.value(unit);
  }

  void _updateCategory({
    required CategoryModel categoryModel,
  }) {
    FirebaseFirestore.instance
        .collection("User")
        .doc(AppString.userToken)
        .collection('Food Recipe')
        .doc(categoryModel.uId)
        .set(categoryModel.toJson())
        .then((value) {
      getAllCategories();
    }).catchError(((error) {
      print('Error add Category is ${error.toString()}');
      throw ServerException();
    }));
  }

  Future<Unit> _addCategoryToFirebase({
    required CategoryModel categoryModel,
  })async{
   await FirebaseFirestore.instance
        .collection("User")
        .doc(AppString.userToken)
        .collection('Food Recipe')
        .add(categoryModel.toJson())
        .then((value) async{
      CategoryModel newCategoryModel = CategoryModel(
          name: categoryModel.name, image: categoryModel.image, uId: value.id);
     await FirebaseFirestore.instance
          .collection("User")
          .doc(AppString.userToken)
          .collection('Food Recipe')
          .doc(value.id)
          .set(newCategoryModel.toJson())
          .then((value) {
        //getAllCategories();
           print("add done");
      });
    }).catchError(((error) {
      print('Error add Category is ${error.toString()}');
      // throw ServerException();
    }));
  return Future.value(unit);
  }

  dynamic uploadImageToFirebase() async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'CategoryImages/${Uri.file(categoryImage?.path as String).pathSegments.last}')
        .putFile(categoryImage as File);
  }
}
