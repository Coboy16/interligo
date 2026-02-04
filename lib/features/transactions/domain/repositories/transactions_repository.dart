import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionsRepository {
  Future<Either<Failure, PaginatedTransactions>> getTransactions({
    required String accountId,
    int page = 1,
  });
}
