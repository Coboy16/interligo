import 'package:drift/drift.dart';

class TransactionsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get transactionId => text().unique()();
  TextColumn get accountId => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  TextColumn get description => text()();
  TextColumn get type => text()(); // 'income' | 'expense'
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
}
