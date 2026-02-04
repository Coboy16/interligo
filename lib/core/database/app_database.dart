import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../utils/logger_util.dart';
import 'tables/accounts_table.dart';
import 'tables/cards_table.dart';
import 'tables/transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AccountsTable, TransactionsTable, CardsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

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
      LoggerUtil.logDatabaseEvent('Accounts', 'INSERT_BATCH', data: accounts);
      batch.insertAllOnConflictUpdate(accountsTable, accounts);
    });
  }

  Future<void> clearAccounts() {
    LoggerUtil.logDatabaseEvent('Accounts', 'DELETE_ALL');
    return delete(accountsTable).go();
  }

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
      LoggerUtil.logDatabaseEvent(
        'Transactions',
        'INSERT_BATCH',
        data: transactions,
      );
      batch.insertAllOnConflictUpdate(transactionsTable, transactions);
    });
  }

  Future<void> clearTransactionsByAccountId(String accountId) {
    LoggerUtil.logDatabaseEvent(
      'Transactions',
      'DELETE_BY_ACCOUNT',
      data: {'accountId': accountId},
    );
    return (delete(
      transactionsTable,
    )..where((t) => t.accountId.equals(accountId))).go();
  }

  // ========== CARDS ==========
  Future<List<CardsTableData>> getAllCards() => select(cardsTable).get();

  Future<CardsTableData?> getCardById(String cardId) => (select(
    cardsTable,
  )..where((t) => t.cardId.equals(cardId))).getSingleOrNull();

  Future<void> insertCards(List<CardsTableCompanion> cards) async {
    await batch((batch) {
      LoggerUtil.logDatabaseEvent('Cards', 'INSERT_BATCH', data: cards);
      batch.insertAllOnConflictUpdate(cardsTable, cards);
    });
  }

  Future<void> updateCardStatus(String cardId, String status) {
    LoggerUtil.logDatabaseEvent(
      'Cards',
      'UPDATE_STATUS',
      data: {'cardId': cardId, 'status': status},
    );
    return (update(cardsTable)..where((t) => t.cardId.equals(cardId))).write(
      CardsTableCompanion(status: Value(status)),
    );
  }

  Future<void> clearCards() {
    LoggerUtil.logDatabaseEvent('Cards', 'DELETE_ALL');
    return delete(cardsTable).go();
  }

  // ========== CLEAR ALL ==========
  Future<void> clearAllData() async {
    LoggerUtil.logDatabaseEvent('DATABASE', 'CLEAR_ALL_DATA');
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
