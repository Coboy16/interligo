import 'package:equatable/equatable.dart';

import '../../domain/entities/card_entity.dart';

abstract class CardsEvent extends Equatable {
  const CardsEvent();

  @override
  List<Object?> get props => [];
}

class CardsLoadRequested extends CardsEvent {
  const CardsLoadRequested();
}

class CardsRefreshRequested extends CardsEvent {
  const CardsRefreshRequested();
}

class CardFreezeToggled extends CardsEvent {
  final String cardId;
  final CardStatus newStatus;

  const CardFreezeToggled({
    required this.cardId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [cardId, newStatus];
}
