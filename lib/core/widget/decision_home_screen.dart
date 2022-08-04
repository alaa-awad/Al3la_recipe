import 'package:al3la_recipe/features/category/presentation/pages/category_page.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../dio/cache_helper.dart';
import '../strings/app_string.dart';
import '../var.dart';

void decisionHomeScreen(){
  AppString.userToken = CacheHelper.getData(key:'uId');
  if (AppString.userToken != null) {
    home =const CategoriesPage();
  } else {
    home =  LoginScreen();
  }
}