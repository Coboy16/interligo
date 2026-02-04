import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../models/account_model.dart';

abstract class AccountsLocalDataSource {
  Future<List<AccountModel>> getAccounts();
  Future<AccountModel?> getAccountById(String id);
  Future<void> cacheAccounts(List<AccountModel> accounts);
  Future<void> clearAccounts();
}

class AccountsLocalDataSourceImpl implements AccountsLocalDataSource {
  final AppDatabase _database;

  AccountsLocalDataSourceImpl(this._database);

  @override
  Future<List<AccountModel>> getAccounts() async {
    try {
      final accounts = await _database.getAllAccounts();
      return accounts.map((data) => AccountModel.fromTableData(data)).toList();
    } catch (e) {
      throw CacheException(message: 'Error al obtener cuentas del cache');
    }
  }

  @override
  Future<AccountModel?> getAccountById(String id) async {
    try {
      final account = await _database.getAccountById(id);
      if (account == null) return null;
      return AccountModel.fromTableData(account);
    } catch (e) {
      throw CacheException(message: 'Error al obtener cuenta del cache');
    }
  }

  @override
  Future<void> cacheAccounts(List<AccountModel> accounts) async {
    try {
      final companions = accounts.map((a) => a.toTableCompanion()).toList();
      await _database.insertAccounts(companions);
    } catch (e) {
      throw CacheException(message: 'Error al guardar cuentas en cache');
    }
  }

  @override
  Future<void> clearAccounts() async {
    try {
      await _database.clearAccounts();
    } catch (e) {
      throw CacheException(message: 'Error al limpiar cache de cuentas');
    }
  }
}
