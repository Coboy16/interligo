import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/card_entity.dart';
import '../repositories/cards_repository.dart';

class ToggleCardFreezeUseCase {
  final CardsRepository repository;

  ToggleCardFreezeUseCase(this.repository);

  Future<Either<Failure, CardEntity>> call(
    String cardId,
    CardStatus newStatus,
  ) {
    return repository.toggleCardFreeze(cardId, newStatus);
  }
}
