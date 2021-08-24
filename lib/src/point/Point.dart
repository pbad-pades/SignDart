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

  Point mul(s) {
  s = decodeBigInt(s);
  s = s % this.curve.order;

  return this.curve.mul_point(s, this);
  }


}