import 'package:flutter_test/flutter_test.dart';
import 'package:interligo/features/cards/domain/entities/card_entity.dart';

void main() {
  group('CardEntity', () {
    const tCard = CardEntity(
      id: 'card_001',
      cardNumberMasked: '**** **** **** 4532',
      holderName: 'JOHN DOE',
      type: CardType.debit,
      brand: CardBrand.visa,
      status: CardStatus.active,
      expiryDate: '12/29',
      cvvMasked: '***',
    );

    test('should return correct last four digits', () {
      expect(tCard.lastFour, '4532');
    });

    test('should return true for isActive when status is active', () {
      expect(tCard.isActive, true);
      expect(tCard.isFrozen, false);
    });

    test('should return true for isFrozen when status is frozen', () {
      const frozenCard = CardEntity(
        id: 'card_002',
        cardNumberMasked: '**** **** **** 8821',
        holderName: 'JOHN DOE',
        type: CardType.credit,
        brand: CardBrand.mastercard,
        status: CardStatus.frozen,
        expiryDate: '06/28',
        cvvMasked: '***',
      );

      expect(frozenCard.isFrozen, true);
      expect(frozenCard.isActive, false);
    });

    test('should return correct brand display name', () {
      expect(tCard.brandDisplayName, 'VISA');

      const mastercardCard = CardEntity(
        id: 'card_002',
        cardNumberMasked: '**** **** **** 8821',
        holderName: 'JOHN DOE',
        type: CardType.debit,
        brand: CardBrand.mastercard,
        status: CardStatus.active,
        expiryDate: '06/28',
        cvvMasked: '***',
      );

      expect(mastercardCard.brandDisplayName, 'MASTERCARD');
    });

    test('copyWith should create a new instance with updated values', () {
      final updatedCard = tCard.copyWith(status: CardStatus.frozen);

      expect(updatedCard.id, tCard.id);
      expect(updatedCard.cardNumberMasked, tCard.cardNumberMasked);
      expect(updatedCard.brand, tCard.brand);
      expect(updatedCard.holderName, tCard.holderName);
      expect(updatedCard.status, CardStatus.frozen);
    });

    test('should support value equality', () {
      const card1 = CardEntity(
        id: 'card_001',
        cardNumberMasked: '**** **** **** 4532',
        holderName: 'JOHN DOE',
        type: CardType.debit,
        brand: CardBrand.visa,
        status: CardStatus.active,
        expiryDate: '12/29',
        cvvMasked: '***',
      );

      const card2 = CardEntity(
        id: 'card_001',
        cardNumberMasked: '**** **** **** 4532',
        holderName: 'JOHN DOE',
        type: CardType.debit,
        brand: CardBrand.visa,
        status: CardStatus.active,
        expiryDate: '12/29',
        cvvMasked: '***',
      );

      expect(card1, card2);
    });
  });
}
