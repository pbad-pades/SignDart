import 'dart:typed_data';

import '../errors/signature_size_exception.dart';
import '../point/point.dart';
import '../utils/big_int_helpers.dart';
import '../utils/endianness.dart';
import '../utils/hash_helper.dart';

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

  bool verify(Uint8List message, Uint8List signature) {
    if (signature.length != this.curve.signatureSize) {
      throw SignatureSizeException(this.curve.signatureSize);
    }

    Curve curve = this.curve;
    BigInt order = curve.order;
    int signatureSize = curve.signatureSize;
    Uint8List A = this.publicKey;

    Uint8List R = signature.sublist(0, signatureSize >> 1);

    Uint8List S = toLittleEndian(signature.sublist(signatureSize >> 1));

    Point pointR = curve.decodePoint(R);
    Point pointA = curve.decodePoint(A);

    Shake256 hash = curve.hash;
    Uint8List curveSigner;

    if (curve.curveName == 'Ed448') {
      String m = 'SigEd448' + String.fromCharCodes([0x00, 0x00]);
      curveSigner = Uint8List.fromList(m.codeUnits);
    } else if (curve.curveName == 'Ed521') {
      String m = 'SigEd521' + String.fromCharCodes([0x00, 0x00]);
      curveSigner = Uint8List.fromList(m.codeUnits);
    } else {
      throw Exception("Curve not supported");
    }

    hash.update(curveSigner);
    hash.update(R);
    hash.update(A);
    hash.update(message);

    Uint8List k = hash.digest(signatureSize);
    k = toLittleEndian(k);

    BigInt reducedK = decodeBigInt(k) % order;
    k = encodeBigInt(reducedK, curve.keySize);

    Point left = pointA.mul(k).add(pointR);

    Point right = curve.generator.mul(S);

    return left == right;
  }
}
