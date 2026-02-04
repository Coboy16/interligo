import '../../domain/entities/token_entity.dart';

class TokenModel extends TokenEntity {
  const TokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresIn,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
    };
  }

  @override
  String toString() {
    return 'TokenModel(accessToken: ${accessToken.substring(0, 5)}..., expiresIn: $expiresIn)';
  }
}
