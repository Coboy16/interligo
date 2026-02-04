import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/card_model.dart';

abstract class CardsLocalDataSource {
  Future<List<CardModel>> getCards();
  Future<CardModel?> getCardById(String id);
  Future<void> cacheCards(List<CardModel> cards);
  Future<void> updateCardStatus(String cardId, String status);
  Future<void> clearCards();
}

class CardsLocalDataSourceImpl implements CardsLocalDataSource {
  final AppDatabase _database;

  CardsLocalDataSourceImpl(this._database);

  @override
  Future<List<CardModel>> getCards() async {
    try {
      final cards = await _database.getAllCards();
      return cards.map((data) => CardModel.fromTableData(data)).toList();
    } catch (e) {
      throw CacheException(message: 'Error al obtener tarjetas del cache');
    }
  }

  @override
  Future<CardModel?> getCardById(String id) async {
    try {
      final card = await _database.getCardById(id);
      if (card == null) return null;
      return CardModel.fromTableData(card);
    } catch (e) {
      throw CacheException(message: 'Error al obtener tarjeta del cache');
    }
  }

  @override
  Future<void> cacheCards(List<CardModel> cards) async {
    try {
      final companions = cards.map((c) => c.toTableCompanion()).toList();
      await _database.insertCards(companions);
    } catch (e) {
      throw CacheException(message: 'Error al guardar tarjetas en cache');
    }
  }

  @override
  Future<void> updateCardStatus(String cardId, String status) async {
    try {
      await _database.updateCardStatus(cardId, status);
    } catch (e) {
      throw CacheException(message: 'Error al actualizar estado de tarjeta en cache');
    }
  }

  @override
  Future<void> clearCards() async {
    try {
      await _database.clearCards();
    } catch (e) {
      throw CacheException(message: 'Error al limpiar cache de tarjetas');
    }
  }
}
