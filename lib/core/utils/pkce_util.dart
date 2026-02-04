import 'dart:convert';
import 'dart:math';
import 'crypto_util.dart';

class PKCEUtil {
  static String generateVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values).replaceAll('=', '');
  }

  static String generateChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = CryptoUtil.sha256Hash(bytes);
    return base64Url.encode(digest).replaceAll('=', '');
  }
}
