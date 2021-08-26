import 'dart:typed_data';

import '../curves/curve.dart';
import '../utils/big_int_helpers.dart';

class Point {
  final BigInt x;
  final BigInt y;
  Curve curve;

  Point(this.x, this.y, this.curve, [bool check = false]) {
    if (check && !curve.isOnCurve(this)) {
      throw Exception("Point not on curve");
    }
  }

  Point mul(Uint8List s) {
    var bigIntS = decodeBigInt(s);
    bigIntS = bigIntS % this.curve.order;

    return this.curve.mulPoint(bigIntS, this);
  }

  void add(Point Q) {
    this.curve.addPoint(this, Q);
  }

  @override
  bool operator ==(other) =>
      (other is Point) &&
      (x == other.x) &&
      (y == other.y) &&
      (curve == other.curve);

  @override
  int get hashCode => x.hashCode + y.hashCode + curve.hashCode;
}
