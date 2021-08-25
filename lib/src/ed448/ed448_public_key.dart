import 'dart:typed_data';
import 'dart:ffi';

import '../errors/key_size_exception.dart';
import '../errors/signature_size_exception.dart';
import '../utils/check_size.dart';
import '../utils/ffi_libdecaf.dart';

import '../utils/converter.dart';

class Ed448PublicKey {
  Uint8List publicKey;
  int _keySize = 57;
  int _signatureSize = 114;

  final _libdecaf = FFILibDecaf();

  Ed448PublicKey.fromBytes(this.publicKey) {
    if (checkEd448KeySize(publicKey)) {
      this.publicKey = publicKey;
    } else {
      throw new KeySizeException(_keySize);
    }
  }

  Uint8List get getPublicKey {
    return this.publicKey;
  }

  bool verify(Uint8List signature, Uint8List message) {
    if (!checkEd448SignatureSize(signature)) {
      throw new SignatureSizeException(_signatureSize);
    }

    final FFISignature = toUint8ListPointer(signature);
    final FFIMessage = toUint8ListPointer(message);
    final FFIPublicKey = toUint8ListPointer(this.publicKey);

    final isValid = _libdecaf.decaf_ed448_verify(FFISignature, FFIPublicKey, FFIMessage, message.length, 0, nullptr, 0);
  
    return isValid == -1 ? true : false;
  }

}