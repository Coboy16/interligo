import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/card_entity.dart';
import '../models/card_model.dart';

abstract class CardsRemoteDataSource {
  Future<List<CardModel>> getCards();
  Future<CardModel> getCardById(String cardId);
  Future<CardModel> updateCardStatus(String cardId, CardStatus newStatus);
}

class CardsRemoteDataSourceImpl implements CardsRemoteDataSource {
  final Dio _dio;

  CardsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CardModel>> getCards() async {
    try {
      final response = await _dio.get(ApiConstants.cards);
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: _extractErrorMessage(responseData) ??
              'Error al obtener tarjetas',
        );
      }

      final data = responseData['data'] as List<dynamic>;
      return data
          .map((json) => CardModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ??
            'Error al obtener tarjetas',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error inesperado al obtener tarjetas');
    }
  }

  @override
  Future<CardModel> getCardById(String cardId) async {
    try {
      final response = await _dio.get(ApiConstants.card(cardId));
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: _extractErrorMessage(responseData) ??
              'Error al obtener tarjeta',
        );
      }

      final data = responseData['data'] as Map<String, dynamic>;
      return CardModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ??
            'Error al obtener tarjeta',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error inesperado al obtener tarjeta');
    }
  }

  @override
  Future<CardModel> updateCardStatus(
    String cardId,
    CardStatus newStatus,
  ) async {
    try {
      final response = await _dio.patch(
        ApiConstants.card(cardId),
        data: {'status': newStatus.name.toUpperCase()},
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: _extractErrorMessage(responseData) ??
              'Error al actualizar estado de tarjeta',
        );
      }

      final data = responseData['data'] as Map<String, dynamic>;
      return CardModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        message: _extractErrorMessage(e.response?.data) ??
            'Error al actualizar estado de tarjeta',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Error inesperado al actualizar estado de tarjeta',
      );
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      if (data['error'] is Map) {
        return data['error']['message'] as String?;
      }
      return data['message'] as String?;
    }
    return null;
  }
}
