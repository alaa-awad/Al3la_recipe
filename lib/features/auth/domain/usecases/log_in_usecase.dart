import 'package:al3la_recipe/features/auth/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class LogInUseCase {
  final UserRepository repository;

  LogInUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
      {required String email, required String password}) async {
    return await repository.logIn(email: email, password: password);
  }
}
