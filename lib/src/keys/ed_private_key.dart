import 'dart:math';
import 'dart:typed_data';

import '../utils/endianness.dart';
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
    Uint8List h = _hashPrivateKey();
    Uint8List leftHalf = h.sublist(0, this.curve.keySize);

    Uint8List s = _getPrivateScalar(leftHalf);

    Point publicKeyPoint = _getPublicKeyPoint(s);

    Uint8List A = curve.encodePoint(publicKeyPoint);

    return EdPublicKey.fromBytes(A, curve);
  }

  Uint8List _getPrivateScalar(leftHalf) {
    Uint8List a = _pruningBuffer(leftHalf);
    Uint8List s = toLittleEndian(a);

    return s;
  }

  Uint8List _getSignaturePrefix(h) {
    Uint8List rightHalf = h.sublist(this.curve.keySize, h.length);

    return rightHalf;
  }

  Point _getPublicKeyPoint(s) {
    Point publicKeyPoint = this.curve.generator.mul(s);

    return publicKeyPoint;
  }

  Uint8List sign(Uint8List message) {
    Curve curve = this.curve;
    Point generator = curve.generator;
    BigInt order = curve.order;

    Uint8List h = this._hashPrivateKey();
    Uint8List leftHalf = h.sublist(0, this.curve.keySize);

    Uint8List s = _getPrivateScalar(leftHalf);

    Point A = _getPublicKeyPoint(s);

    Uint8List prefix = _getSignaturePrefix(h);

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
    hash.update(prefix);
    hash.update(message);
    Uint8List r = hash.digest(curve.signatureSize);

    r = toLittleEndian(r);

    BigInt rBigInt = decodeBigInt(r);
    rBigInt = rBigInt % order;

    r = encodeBigInt(rBigInt, curve.signatureSize);

    Point pointR = generator.mul(r);

    Uint8List R = curve.encodePoint(pointR);

    // Compute S
    Uint8List eA = curve.encodePoint(A);

    hash.update(curveSigner);
    hash.update(R);
    hash.update(eA);
    hash.update(message);
    Uint8List k = hash.digest(curve.signatureSize);

    k = toLittleEndian(k);

    BigInt reducedK = decodeBigInt(k) % order;
    Uint8List S = encodeBigInt(
        (decodeBigInt(r) + (reducedK * decodeBigInt(s))) % order,
        curve.keySize);

    S = toLittleEndian(S);

    return Uint8List.fromList(R + S);
  }

  Uint8List _hashPrivateKey() {
    Shake256 k = this.curve.hash;
    k.update(this.privateKey);

    Uint8List h = k.digest(this.curve.signatureSize);
    return h;
  }

  Uint8List _pruningBuffer(Uint8List a) {
    if (this.curve.curveName == 'Ed448' || 
        this.curve.curveName == 'Ed521') {
      a[0] &= 0xFC;
      a[a.length - 1] = 0;
      a[a.length - 2] |= 0x80;
    } else {
      throw Exception("Curve not supported");
    }

    return a;
  }
}
