import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transactions_repository.dart';

class GetTransactionsUseCase {
  final TransactionsRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<Failure, PaginatedTransactions>> call({
    required String accountId,
    int page = 1,
  }) {
    return repository.getTransactions(accountId: accountId, page: page);
  }
}
