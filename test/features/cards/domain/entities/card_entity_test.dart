import 'package:flutter_test/flutter_test.dart';
import 'package:interligo/features/cards/domain/entities/card_entity.dart';

void main() {
  group('CardEntity', () {
    const tCard = CardEntity(
      id: 'card_001',
      lastFour: '4532',
      type: CardType.visa,
      status: CardStatus.active,
      holderName: 'JOHN DOE',
    );

    test('should return correct masked number', () {
      expect(tCard.maskedNumber, '**** **** **** 4532');
    });

    test('should return true for isActive when status is active', () {
      expect(tCard.isActive, true);
      expect(tCard.isFrozen, false);
    });

    test('should return true for isFrozen when status is frozen', () {
      const frozenCard = CardEntity(
        id: 'card_002',
        lastFour: '8821',
        type: CardType.mastercard,
        status: CardStatus.frozen,
        holderName: 'JOHN DOE',
      );

      expect(frozenCard.isFrozen, true);
      expect(frozenCard.isActive, false);
    });

    test('should return correct type display name', () {
      expect(tCard.typeDisplayName, 'VISA');

      const mastercardCard = CardEntity(
        id: 'card_002',
        lastFour: '8821',
        type: CardType.mastercard,
        status: CardStatus.active,
        holderName: 'JOHN DOE',
      );

      expect(mastercardCard.typeDisplayName, 'MASTERCARD');
    });

    test('copyWith should create a new instance with updated values', () {
      final updatedCard = tCard.copyWith(status: CardStatus.frozen);

      expect(updatedCard.id, tCard.id);
      expect(updatedCard.lastFour, tCard.lastFour);
      expect(updatedCard.type, tCard.type);
      expect(updatedCard.holderName, tCard.holderName);
      expect(updatedCard.status, CardStatus.frozen);
    });

    test('should support value equality', () {
      const card1 = CardEntity(
        id: 'card_001',
        lastFour: '4532',
        type: CardType.visa,
        status: CardStatus.active,
        holderName: 'JOHN DOE',
      );

      const card2 = CardEntity(
        id: 'card_001',
        lastFour: '4532',
        type: CardType.visa,
        status: CardStatus.active,
        holderName: 'JOHN DOE',
      );

      expect(card1, card2);
    });
  });
}
