import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger_util.dart';
import '../models/token_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(TokenModel token);
  Future<TokenModel?> getToken();
  Future<void> clearToken();
  Future<bool> hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthLocalDataSourceImpl(this._storage);

  @override
  Future<void> saveToken(TokenModel token) async {
    try {
      LoggerUtil.logAuthEvent('Guardando Token en Storage Seguro');
      await _storage.write(
        key: StorageConstants.accessToken,
        value: token.accessToken,
      );
      await _storage.write(
        key: StorageConstants.refreshToken,
        value: token.refreshToken,
      );

      final expiryDate = DateTime.now().add(Duration(seconds: token.expiresIn));
      await _storage.write(
        key: StorageConstants.tokenExpiry,
        value: expiryDate.toIso8601String(),
      );
    } catch (e) {
      throw CacheException(message: 'Error al guardar token');
    }
  }

  @override
  Future<TokenModel?> getToken() async {
    try {
      final accessToken = await _storage.read(
        key: StorageConstants.accessToken,
      );
      final refreshToken = await _storage.read(
        key: StorageConstants.refreshToken,
      );
      final expiryStr = await _storage.read(key: StorageConstants.tokenExpiry);

      if (accessToken == null) {
        LoggerUtil.logAuthEvent('No hay token en Storage');
        return null;
      }

      final expiryDate = DateTime.parse(expiryStr!);

      if (DateTime.now().isAfter(expiryDate)) {
        LoggerUtil.logAuthEvent('Token expirado, limpiando storage');
        await clearToken();
        return null;
      }

      LoggerUtil.logAuthEvent('Token recuperado y válido');
      return TokenModel(
        accessToken: accessToken,
        refreshToken: refreshToken!,
        expiresIn: expiryDate.difference(DateTime.now()).inSeconds,
      );
    } catch (e) {
      throw CacheException(message: 'Error al leer token');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      LoggerUtil.logAuthEvent('Limpiando credenciales locales');
      await _storage.delete(key: StorageConstants.accessToken);
      await _storage.delete(key: StorageConstants.refreshToken);
      await _storage.delete(key: StorageConstants.tokenExpiry);
      await _storage.delete(key: StorageConstants.userId);
    } catch (e) {
      throw CacheException(message: 'Error al eliminar token');
    }
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null;
  }
}
