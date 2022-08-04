import 'package:al3la_recipe/core/error/exceptions.dart';
import 'package:al3la_recipe/core/error/failures.dart';
import 'package:al3la_recipe/core/network/network_info.dart';
import 'package:al3la_recipe/core/strings/app_string.dart';
import 'package:al3la_recipe/features/auth/data/datasources/user_local_data_source.dart';
import 'package:al3la_recipe/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:al3la_recipe/features/auth/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Unit>> logIn(
      {required String email, required String password}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logIn(email: email, password: password).then((_){
          localDataSource.saveToken(token: "${AppString.userToken}");
        });
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signUp(
      {required String name, required String email, required String password}) async{
    if(await networkInfo.isConnected){
      try{
        await remoteDataSource.signUp(name: name, email: email, password: password).then((_){
          localDataSource.saveToken(token:"${AppString.userToken}");
        });
        return const Right(unit);
      }
          on ServerException{
        return Left(ServerFailure());
          }
    }
    else{
      return Left(OfflineFailure());
    }
  }
}
