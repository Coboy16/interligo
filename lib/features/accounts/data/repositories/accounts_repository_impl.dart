import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger_util.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/accounts_repository.dart';
import '../datasources/accounts_local_datasource.dart';
import '../datasources/accounts_remote_datasource.dart';

class AccountsRepositoryImpl implements AccountsRepository {
  final AccountsRemoteDataSource remoteDataSource;
  final AccountsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AccountsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AccountEntity>>> getAccounts() async {
    if (await networkInfo.isConnected) {
      try {
        final accounts = await remoteDataSource.getAccounts();
        // Cache is non-fatal - log and continue if it fails
        try {
          await localDataSource.cacheAccounts(accounts);
        } catch (e) {
          LoggerUtil.warning('Failed to cache accounts: $e');
        }
        return Right(accounts);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final cachedAccounts = await localDataSource.getAccounts();
        if (cachedAccounts.isEmpty) {
          return const Left(CacheFailure('No hay cuentas en cache'));
        }
        return Right(cachedAccounts);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> getAccountById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final account = await remoteDataSource.getAccountById(id);
        return Right(account);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final cachedAccount = await localDataSource.getAccountById(id);
        if (cachedAccount == null) {
          return const Left(CacheFailure('Cuenta no encontrada en cache'));
        }
        return Right(cachedAccount);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
