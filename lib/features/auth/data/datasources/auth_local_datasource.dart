import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/storage_constants.dart';
import '../../../../core/error/exceptions.dart';
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
      await _storage.write(
        key: StorageConstants.accessToken,
        value: token.accessToken,
      );
      await _storage.write(
        key: StorageConstants.refreshToken,
        value: token.refreshToken,
      );
      await _storage.write(
        key: StorageConstants.tokenExpiry,
        value: DateTime.now()
            .add(Duration(seconds: token.expiresIn))
            .toIso8601String(),
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

      if (accessToken == null || refreshToken == null) return null;

      return TokenModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: 3600, // Default
      );
    } catch (e) {
      throw CacheException(message: 'Error al leer token');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
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
    try {
      final token = await _storage.read(key: StorageConstants.accessToken);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
