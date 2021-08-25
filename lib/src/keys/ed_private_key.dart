import 'dart:math';
import 'dart:typed_data';

import '../curves/curve.dart';
import '../keys/ed_public_key.dart';
import '../point/point.dart';
import '../utils/big_int_helpers.dart';
import '../utils/hash_helper.dart';

class EdPrivateKey {
  late final Uint8List privateKey;
  final Curve curve;

  EdPrivateKey.fromBytes(this.privateKey, this.curve);

  EdPrivateKey.generate(this.curve) {
    final random = Random.secure();
    final values =
        List<int>.generate(curve.keySize, (_) => random.nextInt(256));
    this.privateKey = Uint8List.fromList(values);
  }

  EdPublicKey getPublicKey() {
    var publicKeyPoint = _getPrivateScalarAndPublicPointAndSignaturePrefix()[1];

    var pubKey = _encodePoint(publicKeyPoint);

    return EdPublicKey.fromBytes(pubKey, curve);
  }

  _getPrivateScalarAndPublicPointAndSignaturePrefix() {
    Uint8List h = this._hashPrivateKey();
    Uint8List leftHalf = h.sublist(0, this.curve.keySize);
    Uint8List rightHalf = h.sublist(this.curve.keySize, h.length);

    Uint8List a = _pruningBuffer(leftHalf);

    // Transform to Little Endian
    Uint8List s = Uint8List.fromList(a.reversed.toList());
    Point publicKeyPoint = this.curve.generator.mul(s);

    return [s, publicKeyPoint, rightHalf];
  }

  Uint8List sign(Uint8List message) {
    Curve curve = this.curve;
    Point generator = curve.generator;
    BigInt order = curve.order;
    int size = curve.signatureSize;

    var result = _getPrivateScalarAndPublicPointAndSignaturePrefix();

    Uint8List s = result[0];
    Point A = result[1];
    Uint8List prefix = result[2];

    Uint8List eA = _encodePoint(A);

    Shake256 hash = curve.hash;
    Uint8List curveSigner;

    if (curve.curveName == 'Ed521') {
      String m = 'SigEd521' + String.fromCharCodes([0x00, 0x00]);
      curveSigner = Uint8List.fromList(m.codeUnits);
    } else {
      throw Exception("Curve not supported");
    }

    hash.update(curveSigner);
    hash.update(prefix);
    hash.update(message);
    Uint8List r = hash.digest(curve.signatureSize);

    // Transform to Little Endian
    r = Uint8List.fromList(r.reversed.toList());

    BigInt rBigInt = decodeBigInt(r);
    rBigInt = rBigInt % order;
    r = encodeBigInt(rBigInt, size);

    Point pointR = generator.mul(r);

    Uint8List R = _encodePoint(pointR);

    // Compute S
    hash.update(curveSigner);
    hash.update(R);
    hash.update(eA);
    hash.update(message);
    Uint8List k = hash.digest(size);

    // Transform to Little Endian
    k = Uint8List.fromList(k.reversed.toList());
    BigInt reducedK = decodeBigInt(k) % order;
    Uint8List S = encodeBigInt(
        (decodeBigInt(r) + (reducedK * decodeBigInt(s))) % order,
        curve.keySize);

    // Transform to Little Endian
    S = Uint8List.fromList(S.reversed.toList());

    return Uint8List.fromList(R + S);
  }

  Uint8List _hashPrivateKey() {
    Shake256 k = this.curve.hash;
    k.update(this.privateKey);

    Uint8List h = k.digest(this.curve.signatureSize);
    return h;
  }

  Uint8List _pruningBuffer(Uint8List a) {
    if (this.curve.curveName == 'Ed521') {
      a[0] &= 0xFC;
      a[a.length - 1] = 0;
      a[a.length - 2] |= 0x80;
    } else {
      throw Exception("Curve not supported");
    }

    return a;
  }

  Uint8List _encodePoint(Point point) {
    // Transform to Little Endian
    var pubKey = Uint8List.fromList(
        encodeBigInt(point.y, this.curve.keySize).reversed.toList());

    // Encoding point
    if (point.x & BigInt.one == BigInt.one) {
      pubKey[pubKey.length - 1] |= 0x80;
    }

    return pubKey;
  }
}
