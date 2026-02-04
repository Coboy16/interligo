import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/card_entity.dart';
import '../models/card_model.dart';

abstract class CardsRemoteDataSource {
  Future<List<CardModel>> getCards();
  Future<CardModel> updateCardStatus(String cardId, CardStatus newStatus);
}

class CardsRemoteDataSourceImpl implements CardsRemoteDataSource {
  final Dio _dio;

  CardsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CardModel>> getCards() async {
    try {
      final response = await _dio.get(ApiConstants.cards);
      final data = response.data as List<dynamic>;
      return data
          .map((json) => CardModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data['message'] as String? ?? 'Error al obtener tarjetas',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Error inesperado al obtener tarjetas');
    }
  }

  @override
  Future<CardModel> updateCardStatus(String cardId, CardStatus newStatus) async {
    try {
      final response = await _dio.patch(
        ApiConstants.card(cardId),
        data: {'status': newStatus.name.toUpperCase()},
      );

      return CardModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] as String? ??
            'Error al actualizar estado de tarjeta',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'Error inesperado al actualizar estado de tarjeta',
      );
    }
  }
}
