import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetCurrentUserUseCase {
  final UserRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      // Try to get cached user first
      final cachedResult = await _repository.getCachedUser();
      final cachedUser = cachedResult.fold((_) => null, (user) => user);
      if (cachedUser != null) {
        return Right(cachedUser);
      }
    }
    return _repository.getCurrentUser();
  }
}
