import 'dart:typed_data';

import '../utils/hash_helper.dart';
import '../point/point.dart';

abstract class Curve {
  late final String curveName;

  // Denotes the prime number defining the underlying field
  late final BigInt field;

  // Order of curve
  late final BigInt order;

  // 'a' equation coefficient
  late final BigInt a;

  // 'd' equation coefficient
  late final BigInt d;

  // The generator point defined over GF(p) of prime order
  late final Point generator;

  // Cofactor of the curve
  late final int cofactor;

  // The hash used in the curve
  late final Shake256 hash;

  // The size of the key generated by the curve
  late final int keySize;

  // The size of the signature generated by the curve
  late final int signatureSize;

  bool isOnCurve(Point P);
  Point mulPoint(BigInt k, Point P);
  Uint8List encodePoint(Point point);
  Point decodePoint(Uint8List encodedPoint);
  Point addPoint(Point point, Point Q);
}