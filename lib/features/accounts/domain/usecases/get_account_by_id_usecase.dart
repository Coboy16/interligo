import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/account_entity.dart';
import '../repositories/accounts_repository.dart';

class GetAccountByIdUseCase {
  final AccountsRepository repository;

  GetAccountByIdUseCase(this.repository);

  Future<Either<Failure, AccountEntity>> call(String id) {
    return repository.getAccountById(id);
  }
}
