import 'package:equatable/equatable.dart';

enum CardStatus { active, frozen }

enum CardType { visa, mastercard }

class CardEntity extends Equatable {
  final String id;
  final String lastFour;
  final CardType type;
  final CardStatus status;
  final String holderName;

  const CardEntity({
    required this.id,
    required this.lastFour,
    required this.type,
    required this.status,
    required this.holderName,
  });

  bool get isActive => status == CardStatus.active;
  bool get isFrozen => status == CardStatus.frozen;

  String get maskedNumber => '**** **** **** $lastFour';

  String get typeDisplayName {
    switch (type) {
      case CardType.visa:
        return 'VISA';
      case CardType.mastercard:
        return 'MASTERCARD';
    }
  }

  CardEntity copyWith({
    String? id,
    String? lastFour,
    CardType? type,
    CardStatus? status,
    String? holderName,
  }) {
    return CardEntity(
      id: id ?? this.id,
      lastFour: lastFour ?? this.lastFour,
      type: type ?? this.type,
      status: status ?? this.status,
      holderName: holderName ?? this.holderName,
    );
  }

  @override
  List<Object?> get props => [id, lastFour, type, status, holderName];
}
