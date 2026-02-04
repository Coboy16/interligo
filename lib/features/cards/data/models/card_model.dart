import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/card_entity.dart';

class CardModel extends CardEntity {
  const CardModel({
    required super.id,
    required super.lastFour,
    required super.type,
    required super.status,
    required super.holderName,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      lastFour: json['last_four'] as String,
      type: _parseType(json['type'] as String),
      status: _parseStatus(json['status'] as String),
      holderName: json['holder_name'] as String,
    );
  }

  static CardType _parseType(String type) {
    switch (type.toUpperCase()) {
      case 'VISA':
        return CardType.visa;
      case 'MASTERCARD':
        return CardType.mastercard;
      default:
        return CardType.visa;
    }
  }

  static CardStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return CardStatus.active;
      case 'FROZEN':
        return CardStatus.frozen;
      default:
        return CardStatus.active;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_four': lastFour,
      'type': type.name.toUpperCase(),
      'status': status.name.toUpperCase(),
      'holder_name': holderName,
    };
  }

  factory CardModel.fromEntity(CardEntity entity) {
    return CardModel(
      id: entity.id,
      lastFour: entity.lastFour,
      type: entity.type,
      status: entity.status,
      holderName: entity.holderName,
    );
  }

  factory CardModel.fromTableData(CardsTableData data) {
    return CardModel(
      id: data.cardId,
      lastFour: data.lastFour,
      type: _parseType(data.type),
      status: _parseStatus(data.status),
      holderName: data.holderName,
    );
  }

  CardsTableCompanion toTableCompanion() {
    return CardsTableCompanion(
      cardId: Value(id),
      lastFour: Value(lastFour),
      type: Value(type.name.toUpperCase()),
      status: Value(status.name.toUpperCase()),
      holderName: Value(holderName),
    );
  }
}
