import 'package:equatable/equatable.dart';

enum CardStatus { active, frozen, blocked }

enum CardBrand { visa, mastercard }

enum CardType { debit, credit }

class CardEntity extends Equatable {
  final String id;
  final String? userId;
  final String? accountId;
  final String cardNumberMasked;
  final String holderName;
  final CardType type;
  final CardBrand brand;
  final CardStatus status;
  final String expiryDate;
  final String cvvMasked;

  const CardEntity({
    required this.id,
    this.userId,
    this.accountId,
    required this.cardNumberMasked,
    required this.holderName,
    required this.type,
    required this.brand,
    required this.status,
    required this.expiryDate,
    required this.cvvMasked,
  });

  bool get isActive => status == CardStatus.active;
  bool get isFrozen => status == CardStatus.frozen;
  bool get isBlocked => status == CardStatus.blocked;

  String get lastFour {
    final cleaned = cardNumberMasked.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length >= 4) {
      return cleaned.substring(cleaned.length - 4);
    }
    return cleaned;
  }

  String get brandDisplayName {
    switch (brand) {
      case CardBrand.visa:
        return 'VISA';
      case CardBrand.mastercard:
        return 'MASTERCARD';
    }
  }

  String get typeDisplayName {
    switch (type) {
      case CardType.debit:
        return 'Débito';
      case CardType.credit:
        return 'Crédito';
    }
  }

  CardEntity copyWith({
    String? id,
    String? userId,
    String? accountId,
    String? cardNumberMasked,
    String? holderName,
    CardType? type,
    CardBrand? brand,
    CardStatus? status,
    String? expiryDate,
    String? cvvMasked,
  }) {
    return CardEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      cardNumberMasked: cardNumberMasked ?? this.cardNumberMasked,
      holderName: holderName ?? this.holderName,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      status: status ?? this.status,
      expiryDate: expiryDate ?? this.expiryDate,
      cvvMasked: cvvMasked ?? this.cvvMasked,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    accountId,
    cardNumberMasked,
    holderName,
    type,
    brand,
    status,
    expiryDate,
    cvvMasked,
  ];
}
