import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/card_entity.dart';

abstract class CardsRepository {
  Future<Either<Failure, List<CardEntity>>> getCards();
  Future<Either<Failure, CardEntity>> toggleCardFreeze(
    String cardId,
    CardStatus newStatus,
  );
}
