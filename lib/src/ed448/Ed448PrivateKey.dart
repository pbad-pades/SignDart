
import 'dart:typed_data';
import 'dart:math';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../Errors/KeySizeException.dart';
import '../utils/checkSize.dart';
import '../utils/ffi_libdecaf.dart';
import '../utils/converter.dart';

import 'Ed448PublicKey.dart';

class Ed448PrivateKey {
  late Uint8List privateKey;
  int _keySize = 57;
  int _signatureSize = 114;

  final _libdecaf = FFILibDecaf();

  Ed448PrivateKey.fromBytes(Uint8List privateKey) {
    if (checkEd448KeySize(privateKey)) {
      this.privateKey = privateKey;
    } else {
      throw new KeySizeException(_keySize);
    }
  }

  Ed448PrivateKey.generate() {
    final random = Random.secure();
    final values = List<int>.generate(_keySize, (_) => random.nextInt(256));

    this.privateKey = Uint8List.fromList(values);
  }

  Uint8List get getPrivateKey {
    return this.privateKey;
  }

  Ed448PublicKey publicKey() {
    final FFIPublicKey = calloc<Uint8>(_keySize);
    final FFIPrivateKey = toUint8ListPointer(this.privateKey);

    _libdecaf.decaf_ed448_derive_public_key(FFIPublicKey, FFIPrivateKey);

    var publicKey = Uint8List.fromList(FFIPublicKey.asTypedList(_keySize));
    return Ed448PublicKey.fromBytes(publicKey);
  }

  /// Signs a message [message] and returns a signature.
  Uint8List sign(Uint8List message) {
    final FFIMessage = toUint8ListPointer(message);
    final publicKey = this.publicKey();
    final FFIPublicKey = toUint8ListPointer(publicKey.getPublicKey);
    final FFIPrivateKey = toUint8ListPointer(this.privateKey);
    final FFISignature = malloc<Uint8>(_signatureSize);

    _libdecaf.decaf_ed448_sign(FFISignature, FFIPrivateKey, FFIPublicKey, FFIMessage, message.length, 0, nullptr, 0);

    final signature = Uint8List.fromList(FFISignature.asTypedList(_signatureSize));
    return signature;
  }

}