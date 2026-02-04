import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_cards_usecase.dart';
import '../../domain/usecases/toggle_card_freeze_usecase.dart';
import 'cards_event.dart';
import 'cards_state.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final GetCardsUseCase getCardsUseCase;
  final ToggleCardFreezeUseCase toggleCardFreezeUseCase;

  CardsBloc({
    required this.getCardsUseCase,
    required this.toggleCardFreezeUseCase,
  }) : super(const CardsInitial()) {
    on<CardsLoadRequested>(_onLoadCards);
    on<CardsRefreshRequested>(_onRefreshCards);
    on<CardFreezeToggled>(_onToggleFreeze);
  }

  Future<void> _onLoadCards(
    CardsLoadRequested event,
    Emitter<CardsState> emit,
  ) async {
    emit(const CardsLoading());

    final result = await getCardsUseCase();

    result.fold(
      (failure) => emit(CardsError(failure.message)),
      (cards) => emit(CardsLoaded(cards: cards)),
    );
  }

  Future<void> _onRefreshCards(
    CardsRefreshRequested event,
    Emitter<CardsState> emit,
  ) async {
    final result = await getCardsUseCase();

    result.fold(
      (failure) => emit(CardsError(failure.message)),
      (cards) => emit(CardsLoaded(cards: cards)),
    );
  }

  Future<void> _onToggleFreeze(
    CardFreezeToggled event,
    Emitter<CardsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CardsLoaded) return;

    // Show loading state for the specific card
    emit(currentState.copyWith(updatingCardId: event.cardId));

    final result = await toggleCardFreezeUseCase(event.cardId, event.newStatus);

    result.fold(
      (failure) => emit(
        CardUpdateError(message: failure.message, cards: currentState.cards),
      ),
      (updatedCard) {
        final updatedCards = currentState.cards.map((card) {
          if (card.id == updatedCard.id) {
            return updatedCard;
          }
          return card;
        }).toList();

        emit(CardUpdateSuccess(card: updatedCard, cards: updatedCards));
      },
    );
  }
}
