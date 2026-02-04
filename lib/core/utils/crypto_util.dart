import 'package:crypto/crypto.dart';

class CryptoUtil {
  static List<int> sha256Hash(List<int> bytes) {
    return sha256.convert(bytes).bytes;
  }
}
