import 'dart:typed_data';

import '../Errors/KeySizeException.dart';
import '../curves/Curve.dart';

class EdPublicKey {
  late final Uint8List publicKey; 
  final Curve curve;

  EdPublicKey.fromBytes(Uint8List publicKey, Curve this.curve) {
    if (publicKey.length == curve.keySize) {
      this.publicKey = publicKey;
    } else {
      throw new KeySizeException(curve.keySize);
    }
  }
}