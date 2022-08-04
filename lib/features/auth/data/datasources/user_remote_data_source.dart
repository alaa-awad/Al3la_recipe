import 'package:al3la_recipe/core/strings/app_string.dart';
import 'package:al3la_recipe/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRemoteDataSource {
  Future<Unit> logIn({required String email, required String password});
  Future<Unit> signUp(
      {required String name, required String email, required String password});
}

class UserRemoteDataSourceFromFirebase implements UserRemoteDataSource {
  @override
  Future<Unit> logIn({required String email, required String password}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password).then((value){
         AppString.userToken =  "${value.user?.uid}";
    });
    return Future.value(unit);
  }

  @override
  Future<Unit> signUp(
      {required String name,
      required String email,
      required String password}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      UserModel user =
          UserModel(id: "${value.user?.uid}", email: email, name: name);
      AppString.userToken = "${value.user?.uid}";
      FirebaseFirestore.instance
          .collection('User')
          .doc(value.user?.uid)
          .set(user.toJson());
    });

    return Future.value(unit);
  }
}
