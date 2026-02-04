import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/accounts_table.dart';
import 'tables/cards_table.dart';
import 'tables/transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AccountsTable, TransactionsTable, CardsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // For testing
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  // ========== ACCOUNTS ==========
  Future<List<AccountsTableData>> getAllAccounts() =>
      select(accountsTable).get();

  Future<AccountsTableData?> getAccountById(String accountId) => (select(
    accountsTable,
  )..where((t) => t.accountId.equals(accountId))).getSingleOrNull();

  Future<void> insertAccounts(List<AccountsTableCompanion> accounts) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(accountsTable, accounts);
    });
  }

  Future<void> clearAccounts() => delete(accountsTable).go();

  // ========== TRANSACTIONS ==========
  Future<List<TransactionsTableData>> getTransactionsByAccountId(
    String accountId,
  ) =>
      (select(transactionsTable)
            ..where((t) => t.accountId.equals(accountId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<void> insertTransactions(
    List<TransactionsTableCompanion> transactions,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(transactionsTable, transactions);
    });
  }

  Future<void> clearTransactionsByAccountId(String accountId) => (delete(
    transactionsTable,
  )..where((t) => t.accountId.equals(accountId))).go();

  // ========== CARDS ==========
  Future<List<CardsTableData>> getAllCards() => select(cardsTable).get();

  Future<CardsTableData?> getCardById(String cardId) => (select(
    cardsTable,
  )..where((t) => t.cardId.equals(cardId))).getSingleOrNull();

  Future<void> insertCards(List<CardsTableCompanion> cards) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(cardsTable, cards);
    });
  }

  Future<void> updateCardStatus(String cardId, String status) =>
      (update(cardsTable)..where((t) => t.cardId.equals(cardId))).write(
        CardsTableCompanion(status: Value(status)),
      );

  Future<void> clearCards() => delete(cardsTable).go();

  // ========== CLEAR ALL ==========
  Future<void> clearAllData() async {
    await clearAccounts();
    await delete(transactionsTable).go();
    await clearCards();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'interligo.db'));
    return NativeDatabase.createInBackground(file);
  });
}
