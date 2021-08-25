import 'dart:typed_data';

import '../errors/key_size_exception.dart';
import '../curves/curve.dart';

class EdPublicKey {
  late final Uint8List publicKey; 
  final Curve curve;

  EdPublicKey.fromBytes(Uint8List publicKey, this.curve) {
    if (publicKey.length == curve.keySize) {
      this.publicKey = publicKey;
    } else {
      throw KeySizeException(curve.keySize);
    }
  }
}