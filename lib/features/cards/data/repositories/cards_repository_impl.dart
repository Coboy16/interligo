import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger_util.dart';
import '../../domain/entities/card_entity.dart';
import '../../domain/repositories/cards_repository.dart';
import '../datasources/cards_local_datasource.dart';
import '../datasources/cards_remote_datasource.dart';

class CardsRepositoryImpl implements CardsRepository {
  final CardsRemoteDataSource remoteDataSource;
  final CardsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CardsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CardEntity>>> getCards() async {
    if (await networkInfo.isConnected) {
      try {
        final cards = await remoteDataSource.getCards();
        // Cache is non-fatal - log and continue if it fails
        try {
          await localDataSource.cacheCards(cards);
        } catch (e) {
          LoggerUtil.warning('Failed to cache cards: $e');
        }
        return Right(cards);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final cachedCards = await localDataSource.getCards();
        if (cachedCards.isEmpty) {
          return const Left(CacheFailure('No hay tarjetas en cache'));
        }
        return Right(cachedCards);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, CardEntity>> toggleCardFreeze(
    String cardId,
    CardStatus newStatus,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure('Se requiere conexión para modificar tarjetas'),
      );
    }

    try {
      final card = await remoteDataSource.updateCardStatus(cardId, newStatus);
      // Cache update is non-fatal
      try {
        await localDataSource.updateCardStatus(
          cardId,
          newStatus.name.toUpperCase(),
        );
      } catch (e) {
        LoggerUtil.warning('Failed to update card status in cache: $e');
      }
      return Right(card);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
