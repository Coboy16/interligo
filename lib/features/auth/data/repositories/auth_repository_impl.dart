import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TokenEntity>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure('Se requiere conexión a internet para iniciar sesión'),
      );
    }

    try {
      final loginResponse = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.saveToken(loginResponse.token);
      await localDataSource.saveUser(loginResponse.user);
      return Right(loginResponse.token);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return const Left(AuthFailure('Error inesperado al iniciar sesión'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Try to logout from server (don't fail if it errors)
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }
      // Always clear local data
      await localDataSource.clearAll();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      // Still try to clear local data on any error
      try {
        await localDataSource.clearAll();
      } catch (_) {}
      return const Left(CacheFailure('Error al cerrar sesión'));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final hasToken = await localDataSource.hasToken();
      return Right(hasToken);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, TokenEntity>> refreshToken() async {
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure('Se requiere conexión a internet para refrescar sesión'),
      );
    }

    try {
      final currentRefreshToken = await localDataSource.getRefreshToken();
      if (currentRefreshToken == null) {
        return const Left(
          AuthFailure('Sesión expirada. Por favor inicia sesión nuevamente.'),
        );
      }

      final newToken = await remoteDataSource.refreshToken(currentRefreshToken);
      await localDataSource.saveToken(newToken);
      return Right(newToken);
    } on ServerException catch (e) {
      // Clear tokens on refresh failure
      await localDataSource.clearAll();
      return Left(AuthFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return const Left(
        AuthFailure('Sesión expirada. Por favor inicia sesión nuevamente.'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (!await networkInfo.isConnected) {
      // Try to get cached user if offline
      final cachedResult = await getCachedUser();
      return cachedResult.fold(
        (failure) => const Left(
          NetworkFailure('Se requiere conexión a internet'),
        ),
        (user) => user != null
            ? Right(user)
            : const Left(AuthFailure('Usuario no encontrado')),
      );
    }

    try {
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.saveUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return const Left(AuthFailure('Error al obtener usuario'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return const Right(null);
    }
  }
}
