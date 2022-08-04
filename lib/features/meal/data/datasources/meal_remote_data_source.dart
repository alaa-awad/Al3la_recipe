import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../../core/error/exceptions.dart';
import '../../../../core/strings/app_string.dart';
import '../../../../core/var.dart';
import '../../domain/entities/meal.dart';
import '../models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<Meal>> getAllMeals({required String idCategory});
  Future<Unit> addMeal({required Meal meal, required String uIdCategory});
  Future<Unit> updateMeal({required Meal meal, required String uIdCategory});
  Future<Unit> deleteMeal(
      {required String idMeal, required String uIdCategory});
}

class MealRemoteDataSourceFromFirebase implements MealRemoteDataSource {
  @override
  Future<List<Meal>> getAllMeals({required String idCategory}) async {
    List<MealModel> meals = [];
    await FirebaseFirestore.instance
        .collection("User")
        .doc(AppString.userToken)
        .collection('Food Recipe')
        .doc(idCategory)
        .collection('Meals')
        .get()
        .then((value) {
      for (var element in value.docs) {
        meals.add(MealModel.fromJson(element.data()));
      }
      mealsList = meals;
    }).catchError((error) {
      print('Error get Meal is ${error.toString()}');
      throw ServerException();
    });
    return meals;
  }

  @override
  Future<Unit> addMeal(
      {required Meal meal, required String uIdCategory}) async {
    if (mealImage != null) {
      await uploadImageToFirebase().then((value) {
        value.ref
            .getDownloadURL()
            .then((value) {
              print("value is $value");
              MealModel mealModel = MealModel(
                  uId: "",
                  name: meal.name,
                  ingredients: meal.ingredients,
                  note: meal.note,
                  image: value,
                  describe: meal.describe);
              _addMealToFirebase(meal: mealModel, idCategory: uIdCategory);
            })
            .then((_) {})
            .catchError((error) {
              print('error getDownloadURL ${error.toString()}');
            });
      }).catchError((error) {
        print('error putFile ${error.toString()}');
      });
    } else {
      MealModel mealModel = MealModel(
          uId: "",
          name: meal.name,
          ingredients: meal.ingredients,
          note: meal.note,
          image: null,
          describe: meal.describe);
      _addMealToFirebase(meal: mealModel, idCategory: uIdCategory);
    }
    return Future.value(unit);
  }

  @override
  Future<Unit> deleteMeal(
      {required String idMeal, required String uIdCategory}) {
    FirebaseFirestore.instance
        .collection("User")
        .doc(AppString.userToken)
        .collection('Food Recipe')
        .doc(uIdCategory)
        .collection('Meals')
        .doc(idMeal)
        .delete()
        .then((value) {
      print('delete meal done');
    }).catchError((error) {
      print("Error delete meal is ${error.toString()}");
      throw ServerException();
    });
    return Future.value(unit);
  }

  @override
  Future<Unit> updateMeal(
      {required Meal meal, required String uIdCategory}) async {
    if (mealImage != null) {
      await uploadImageToFirebase().then((value) {
        value.ref.getDownloadURL().then((value) {
          MealModel mealModel = MealModel(
              uId: meal.uId,
              name: meal.name,
              ingredients: meal.ingredients,
              note: meal.note,
              image: value,
              describe: meal.describe);
          _updateMeal(mealModel: mealModel, idCategory: uIdCategory);
          print(value);
        }).catchError((error) {
          print('error getDownloadURL ${error.toString()}');
        });
      }).catchError((error) {
        print('error putFile ${error.toString()}');
      });
    } else {
      MealModel mealModel = MealModel(
          uId: meal.uId,
          name: meal.name,
          ingredients: meal.ingredients,
          note: meal.note,
          image: meal.image,
          describe: meal.describe);
      _updateMeal(mealModel: mealModel, idCategory: uIdCategory);
    }
    return Future.value(unit);
  }

  dynamic uploadImageToFirebase() async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'MealImages/${Uri.file(mealImage?.path as String).pathSegments.last}')
        .putFile(mealImage as File);
  }

  void _updateMeal({
    required MealModel mealModel,
    required String idCategory,
  })  {
     FirebaseFirestore.instance
        .collection("User")
        .doc(AppString.userToken)
        .collection('Food Recipe')
        .doc(idCategory)
        .collection('Meals')
        .doc(mealModel.uId)
        .set(mealModel.toJson())
        .then((value) {})
        .catchError(((error) {
      print('Error update meal is ${error.toString()}');
      throw ServerException();
    }));
  }

  void _addMealToFirebase({
    required MealModel meal,
    required String idCategory,
  }) {
    FirebaseFirestore.instance
        .collection("User")
        .doc(AppString.userToken)
        .collection('Food Recipe')
        .doc(idCategory)
        .collection('Meals')
        .add(meal.toJson())
        .then((value) {
      MealModel mealModel = MealModel(
          uId: value.id,
          name: meal.name,
          ingredients: meal.ingredients,
          describe: meal.describe,
          note: meal.note,
          image: meal.image);
      FirebaseFirestore.instance
          .collection("User")
          .doc(AppString.userToken)
          .collection('Food Recipe')
          .doc(idCategory)
          .collection('Meals')
          .doc(value.id)
          .set(mealModel.toJson())
          .then((value) {
        getAllMeals(idCategory: idCategory);
      });
    }).catchError(((error) {
      print('Error add meal is ${error.toString()}');
      throw ServerException();
    }));
  }
}
