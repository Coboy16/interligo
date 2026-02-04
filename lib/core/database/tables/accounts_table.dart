import 'package:drift/drift.dart';

class AccountsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountId => text().unique()();
  TextColumn get alias => text()();
  TextColumn get currency => text()();
  RealColumn get availableBalance => real()();
  RealColumn get ledgerBalance => real()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
}
