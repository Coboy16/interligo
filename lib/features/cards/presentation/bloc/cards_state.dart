import 'package:equatable/equatable.dart';

import '../../domain/entities/card_entity.dart';

abstract class CardsState extends Equatable {
  const CardsState();

  @override
  List<Object?> get props => [];
}

class CardsInitial extends CardsState {
  const CardsInitial();
}

class CardsLoading extends CardsState {
  const CardsLoading();
}

class CardsLoaded extends CardsState {
  final List<CardEntity> cards;
  final bool isFromCache;
  final String? updatingCardId;

  const CardsLoaded({
    required this.cards,
    this.isFromCache = false,
    this.updatingCardId,
  });

  CardsLoaded copyWith({
    List<CardEntity>? cards,
    bool? isFromCache,
    String? updatingCardId,
  }) {
    return CardsLoaded(
      cards: cards ?? this.cards,
      isFromCache: isFromCache ?? this.isFromCache,
      updatingCardId: updatingCardId,
    );
  }

  @override
  List<Object?> get props => [cards, isFromCache, updatingCardId];
}

class CardsError extends CardsState {
  final String message;

  const CardsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CardUpdateSuccess extends CardsState {
  final CardEntity card;
  final List<CardEntity> cards;

  const CardUpdateSuccess({required this.card, required this.cards});

  @override
  List<Object?> get props => [card, cards];
}

class CardUpdateError extends CardsState {
  final String message;
  final List<CardEntity> cards;

  const CardUpdateError({required this.message, required this.cards});

  @override
  List<Object?> get props => [message, cards];
}
