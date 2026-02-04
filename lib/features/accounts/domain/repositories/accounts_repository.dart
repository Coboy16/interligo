import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/account_entity.dart';

abstract class AccountsRepository {
  Future<Either<Failure, List<AccountEntity>>> getAccounts();
  Future<Either<Failure, AccountEntity>> getAccountById(String id);
}
