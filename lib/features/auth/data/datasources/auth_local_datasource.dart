import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger_util.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(TokenModel token);
  Future<TokenModel?> getToken();
  Future<String?> getRefreshToken();
  Future<void> clearToken();
  Future<bool> hasToken();

  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();

  Future<void> clearAll();
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
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: StorageConstants.refreshToken);
    } catch (e) {
      throw CacheException(message: 'Error al leer refresh token');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      LoggerUtil.logAuthEvent('Limpiando tokens');
      await _storage.delete(key: StorageConstants.accessToken);
      await _storage.delete(key: StorageConstants.refreshToken);
      await _storage.delete(key: StorageConstants.tokenExpiry);
    } catch (e) {
      throw CacheException(message: 'Error al eliminar token');
    }
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      LoggerUtil.logAuthEvent('Guardando Usuario en Storage Seguro');
      await _storage.write(
        key: StorageConstants.userId,
        value: user.id,
      );
      await _storage.write(
        key: StorageConstants.userUsername,
        value: user.username,
      );
      await _storage.write(
        key: StorageConstants.userEmail,
        value: user.email,
      );
      if (user.name != null) {
        await _storage.write(
          key: StorageConstants.userName,
          value: user.name,
        );
      }
    } catch (e) {
      throw CacheException(message: 'Error al guardar usuario');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final id = await _storage.read(key: StorageConstants.userId);
      final username = await _storage.read(key: StorageConstants.userUsername);
      final email = await _storage.read(key: StorageConstants.userEmail);
      final name = await _storage.read(key: StorageConstants.userName);

      if (id == null || username == null || email == null) {
        LoggerUtil.logAuthEvent('No hay usuario en Storage');
        return null;
      }

      LoggerUtil.logAuthEvent('Usuario recuperado');
      return UserModel(
        id: id,
        username: username,
        email: email,
        name: name,
      );
    } catch (e) {
      throw CacheException(message: 'Error al leer usuario');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      LoggerUtil.logAuthEvent('Limpiando datos de usuario');
      await _storage.delete(key: StorageConstants.userId);
      await _storage.delete(key: StorageConstants.userUsername);
      await _storage.delete(key: StorageConstants.userEmail);
      await _storage.delete(key: StorageConstants.userName);
    } catch (e) {
      throw CacheException(message: 'Error al eliminar usuario');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      LoggerUtil.logAuthEvent('Limpiando todas las credenciales');
      await clearToken();
      await clearUser();
    } catch (e) {
      throw CacheException(message: 'Error al limpiar credenciales');
    }
  }
}
