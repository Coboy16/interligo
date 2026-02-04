import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/token_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, TokenEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> isAuthenticated();

  Future<Either<Failure, TokenEntity>> refreshToken();
}
