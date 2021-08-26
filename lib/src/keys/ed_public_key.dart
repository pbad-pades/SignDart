import 'dart:typed_data';

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
    Curve curve = this.curve;
    BigInt order = curve.order;
    int size = curve.signatureSize;

    List<Uint8List> result = _decodeSignature(signature);

    Uint8List eR = result[0];
    Uint8List S = result[1];

    eR = toLittleEndian(eR);
    Point R = curve.decodePoint(eR);

    Shake256 hash = curve.hash;
    Uint8List curveSigner;

    if (curve.curveName == 'Ed521') {
      String m = 'SigEd521' + String.fromCharCodes([0x00, 0x00]);
      curveSigner = Uint8List.fromList(m.codeUnits);
    } else {
      throw Exception("Curve not supported");
    }

    hash.update(curveSigner);
    hash.update(eR);
    hash.update(this.publicKey);
    hash.update(message);

    Uint8List k = hash.digest(curve.signatureSize);
    k = toLittleEndian(k);

    var kBigInt = decodeBigInt(k);

    kBigInt = kBigInt % order;

    var A = this.publicKey;
    var pA = curve.decodePoint(A);

    k = encodeBigInt(kBigInt, curve.keySize);

    var left = pA.mul(k).add(R);
    var right = curve.generator.mul(S);

    return left == right;
  }

  List<Uint8List> _decodeSignature(Uint8List signature) {
    int l = signature.length;
    if (l & 1 != 0) {
      return [Uint8List(0), Uint8List(0)];
    }
    l = l >> 1;

    var R = toLittleEndian(signature.sublist(0, l));
    var S = toLittleEndian(signature.sublist(l));

    return [R, S];
  }
}
