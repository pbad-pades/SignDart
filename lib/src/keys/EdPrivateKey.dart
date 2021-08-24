import 'dart:math';
import 'dart:typed_data';

import '../curves/Curve.dart';
import '../keys/EdPublicKey.dart';
import '../utils/bigIntHelpers.dart';
import '../utils/hashHelper.dart';
import '../point/Point.dart';



class EdPrivateKey {
  late final Uint8List privateKey; 
  final Curve curve;

  EdPrivateKey.fromBytes(Uint8List this.privateKey, Curve this.curve);

  EdPrivateKey.generate(Curve this.curve) {
    final random = Random.secure();
    final values = List<int>.generate(curve.keySize, (_) => random.nextInt(256));
    this.privateKey = Uint8List.fromList(values);
  }

  EdPublicKey getPublicKey() {
    var h = this._hashPrivateKey();

    var a = _pruningBuffer(h);

    var publicKeyPoint = _generateScalarAndMultiply(a);

    var pubKey = _encodePoint(publicKeyPoint);
    
    return EdPublicKey.fromBytes(pubKey, curve);
  }

  List<int> _hashPrivateKey() {
    Shake256 k = this.curve.hash;
    k.update(this.privateKey);

    var h = k.digest(this.curve.signatureSize);
    k.reset();
    return h;
  }

  List<int> _pruningBuffer(List<int> h) {
    var a = h.sublist(0, this.curve.keySize);
    h = h.sublist(this.curve.keySize, h.length);

    if (this.curve.curveName == 'Ed521') {
      a[0] &= 0xFC;
      a[a.length-1] = 0;
      a[a.length-2] |= 0x80;
    }

    return a;
  }

  Point _generateScalarAndMultiply(List<int> a) {
    // Transform to Little Endian
    var s = a.reversed.toList();
    var sB = this.curve.generator.mul(s);
    return sB;
  }

  Uint8List _encodePoint(Point publicKeyPoint) {
    // Transform to Little Endian
    var pubKey = Uint8List.fromList(encodeBigInt(publicKeyPoint.y, this.curve.keySize).reversed.toList());

    // Encoding point
    if (publicKeyPoint.x&BigInt.one == BigInt.one) {
      pubKey[pubKey.length-1] |= 0x80;
    }

    return pubKey;
  }

}