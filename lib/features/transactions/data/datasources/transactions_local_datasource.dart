import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/transaction_model.dart';

abstract class TransactionsLocalDataSource {
  Future<List<TransactionModel>> getTransactions(String accountId);
  Future<void> cacheTransactions(
    String accountId,
    List<TransactionModel> transactions,
  );
  Future<void> clearTransactions(String accountId);
}

class TransactionsLocalDataSourceImpl implements TransactionsLocalDataSource {
  final AppDatabase _database;

  TransactionsLocalDataSourceImpl(this._database);

  @override
  Future<List<TransactionModel>> getTransactions(String accountId) async {
    try {
      final transactions = await _database.getTransactionsByAccountId(
        accountId,
      );
      return transactions
          .map((data) => TransactionModel.fromTableData(data))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Error al obtener transacciones del cache');
    }
  }

  @override
  Future<void> cacheTransactions(
    String accountId,
    List<TransactionModel> transactions,
  ) async {
    try {
      // Add accountId to each transaction model
      final transactionsWithAccountId = transactions.map((t) {
        return TransactionModel(
          id: t.id,
          accountId: accountId,
          date: t.date,
          amount: t.amount,
          description: t.description,
          type: t.type,
        );
      }).toList();

      final companions = transactionsWithAccountId
          .map((t) => t.toTableCompanion())
          .toList();
      await _database.insertTransactions(companions);
    } catch (e) {
      throw CacheException(message: 'Error al guardar transacciones en cache');
    }
  }

  @override
  Future<void> clearTransactions(String accountId) async {
    try {
      await _database.clearTransactionsByAccountId(accountId);
    } catch (e) {
      throw CacheException(message: 'Error al limpiar cache de transacciones');
    }
  }
}
