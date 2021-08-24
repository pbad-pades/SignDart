import 'dart:typed_data';

import 'package:sha3/sha3.dart';

class Shake256 {
  SHA3 _hash = SHA3(256, SHAKE_PADDING, 1056);

  Shake256() { 
  }

  update(Uint8List message) {
    this._hash.update(message);
  }

  List<int> digest(int hashLen) {
    var h = this._hash.digest();
    return h.sublist(0, hashLen);
  }

  void reset() {
    this._hash = SHA3(256, SHAKE_PADDING, 1056);
  }
}