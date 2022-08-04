import 'package:al3la_recipe/features/auth/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class SignUpUseCase{
  final UserRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
      {required String name, required String email, required String password})async{
    return await repository.signUp(name: name, email: email, password: password);
  }

}