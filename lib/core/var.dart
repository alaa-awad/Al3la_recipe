
import 'dart:io';

import "package:al3la_recipe/features/category/domain/entities/category.dart";
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../features/meal/domain/entities/meal.dart';

File? categoryImage;

File? mealImage;

//List<Category>? categoryList ;

List<Meal>? mealsList ;

var picker = ImagePicker();

late Widget home;