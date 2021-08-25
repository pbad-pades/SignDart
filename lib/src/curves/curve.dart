import '../utils/hash_helper.dart';

import '../point/point.dart';

abstract class Curve {
  late final String curveName;
  late final BigInt field;
  late final BigInt order;
  late final BigInt a;
  late final BigInt d;
  late final Point generator;
  late final int cofactor;
  late final Shake256 hash;
  late final int keySize;
  late final int signatureSize;

  bool isOnCurve(Point P);
  Point mul_point(BigInt k, Point P);
}