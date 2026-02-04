import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/card_entity.dart';
import '../repositories/cards_repository.dart';

class GetCardsUseCase {
  final CardsRepository repository;

  GetCardsUseCase(this.repository);

  Future<Either<Failure, List<CardEntity>>> call() {
    return repository.getCards();
  }
}
