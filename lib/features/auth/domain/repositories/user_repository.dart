import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, Unit>> signUp(
      {required String name, required String email, required String password});

  Future<Either<Failure, Unit>> logIn(
      {required String email, required String password});

}
