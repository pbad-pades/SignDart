import 'dart:typed_data';

bool checkEd448KeySize(Uint8List key) {
  int keySize = 57;

  if (key.length == keySize) {
    return true;
  } else {
    return false;
  }
}

bool checkEd448SignatureSize(Uint8List signature) {
  int signatureSize = 114;

  if (signature.length == signatureSize) {
    return true;
  } else {
    return false;
  }
}
