import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/card_entity.dart';

class CardModel extends CardEntity {
  const CardModel({
    required super.id,
    super.userId,
    super.accountId,
    required super.cardNumberMasked,
    required super.holderName,
    required super.type,
    required super.brand,
    required super.status,
    required super.expiryDate,
    required super.cvvMasked,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      accountId: json['account_id'] as String?,
      cardNumberMasked: json['card_number_masked'] as String,
      holderName: json['card_holder_name'] as String,
      type: _parseType(json['type'] as String),
      brand: _parseBrand(json['brand'] as String),
      status: _parseStatus(json['status'] as String),
      expiryDate: json['expiry_date'] as String,
      cvvMasked: json['cvv_masked'] as String,
    );
  }

  static CardType _parseType(String type) {
    switch (type.toUpperCase()) {
      case 'DEBIT':
        return CardType.debit;
      case 'CREDIT':
        return CardType.credit;
      default:
        return CardType.debit;
    }
  }

  static CardBrand _parseBrand(String brand) {
    switch (brand.toUpperCase()) {
      case 'VISA':
        return CardBrand.visa;
      case 'MASTERCARD':
        return CardBrand.mastercard;
      default:
        return CardBrand.visa;
    }
  }

  static CardStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return CardStatus.active;
      case 'FROZEN':
        return CardStatus.frozen;
      case 'BLOCKED':
        return CardStatus.blocked;
      default:
        return CardStatus.active;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'account_id': accountId,
      'card_number_masked': cardNumberMasked,
      'card_holder_name': holderName,
      'type': type.name.toUpperCase(),
      'brand': brand.name.toUpperCase(),
      'status': status.name.toUpperCase(),
      'expiry_date': expiryDate,
      'cvv_masked': cvvMasked,
    };
  }

  factory CardModel.fromEntity(CardEntity entity) {
    return CardModel(
      id: entity.id,
      userId: entity.userId,
      accountId: entity.accountId,
      cardNumberMasked: entity.cardNumberMasked,
      holderName: entity.holderName,
      type: entity.type,
      brand: entity.brand,
      status: entity.status,
      expiryDate: entity.expiryDate,
      cvvMasked: entity.cvvMasked,
    );
  }

  factory CardModel.fromTableData(CardsTableData data) {
    return CardModel(
      id: data.cardId,
      cardNumberMasked: '**** **** **** ${data.lastFour}',
      holderName: data.holderName,
      type: _parseType(data.type),
      brand: _parseBrand(data.type), // Fallback: use type as brand for cached data
      status: _parseStatus(data.status),
      expiryDate: '', // Not stored in cache
      cvvMasked: '***', // Not stored in cache
    );
  }

  CardsTableCompanion toTableCompanion() {
    return CardsTableCompanion(
      cardId: Value(id),
      lastFour: Value(lastFour),
      type: Value(brand.name.toUpperCase()), // Store brand for backward compat
      status: Value(status.name.toUpperCase()),
      holderName: Value(holderName),
    );
  }
}
