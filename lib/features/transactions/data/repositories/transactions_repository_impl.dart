import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger_util.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../datasources/transactions_local_datasource.dart';
import '../datasources/transactions_remote_datasource.dart';
import '../models/transaction_model.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDataSource remoteDataSource;
  final TransactionsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TransactionsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PaginatedTransactions>> getTransactions({
    required String accountId,
    int page = 1,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTransactions(
          accountId: accountId,
          page: page,
        );

        // Cache first page - non-fatal if it fails
        if (page == 1) {
          try {
            await localDataSource.cacheTransactions(
              accountId,
              result.transactions.cast<TransactionModel>(),
            );
          } catch (e) {
            LoggerUtil.warning('Failed to cache transactions: $e');
          }
        }

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final cachedTransactions = await localDataSource.getTransactions(
          accountId,
        );

        if (cachedTransactions.isEmpty) {
          return const Left(CacheFailure('No hay transacciones en cache'));
        }

        return Right(
          PaginatedTransactions(
            transactions: cachedTransactions,
            currentPage: 1,
            totalPages: 1,
            totalItems: cachedTransactions.length,
            itemsPerPage: cachedTransactions.length,
          ),
        );
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
