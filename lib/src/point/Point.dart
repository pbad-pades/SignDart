import 'dart:typed_data';

import '../curves/Curve.dart';
import '../utils/bigIntHelpers.dart';

class Point {
  final BigInt x;
  final BigInt y;
  Curve curve;

  Point(BigInt this.x, BigInt this.y, Curve this.curve, [bool check = false]) {
    if (check && !curve.isOnCurve(this)) {
      throw Exception("Point not on curve");
    } 
  }

  Point mul(Uint8List s) {
  var bigIntS = decodeBigInt(s);
  bigIntS = bigIntS % this.curve.order;

  return this.curve.mul_point(bigIntS, this);
  }


}