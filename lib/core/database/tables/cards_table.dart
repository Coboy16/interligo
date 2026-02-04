import 'package:drift/drift.dart';

class CardsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cardId => text().unique()();
  TextColumn get lastFour => text()();
  TextColumn get type => text()(); // 'VISA' | 'MASTERCARD'
  TextColumn get status => text()(); // 'ACTIVE' | 'FROZEN'
  TextColumn get holderName => text()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
}
