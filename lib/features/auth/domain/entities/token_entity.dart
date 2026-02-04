import 'package:equatable/equatable.dart';

class TokenEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  bool get isExpired {
    // This would need to be calculated based on when the token was received
    // For simplicity, we assume it's valid
    return false;
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresIn];
}
