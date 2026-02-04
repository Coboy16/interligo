import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthRepository _authRepository;

  UserRepositoryImpl(this._authRepository);

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() {
    return _authRepository.getCurrentUser();
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() {
    return _authRepository.getCachedUser();
  }
}
