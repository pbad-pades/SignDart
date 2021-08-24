import 'dart:typed_data';

/// Decode a BigInt from bytes in big-endian encoding.
BigInt decodeBigInt(List<int> bytes) {
  BigInt result = new BigInt.from(0);
  for (int i = 0; i < bytes.length; i++) {
    result += new BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
  }
  return result;
}

/// Encode a BigInt into bytes using big-endian encoding.
Uint8List encodeBigInt(BigInt number, int sizeKey) {
  // Not handling negative numbers. Decide how you want to do that.
  var result = new Uint8List(sizeKey);
  for (int i = 0; i < sizeKey; i++) {
    result[sizeKey - i - 1] = (number & BigInt.from(0xff)).toInt();
    number = number >> 8;
  }
  return result;
}