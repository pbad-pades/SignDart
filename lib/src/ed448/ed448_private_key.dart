
import 'dart:typed_data';
import 'dart:math';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../errors/key_size_exception.dart';
import '../utils/check_size.dart';
import '../utils/ffi_libdecaf.dart';
import '../utils/converter.dart';

import 'ed448_public_key.dart';

class Ed448PrivateKey {
  late Uint8List privateKey;
  final int _keySize = 57;
  final int _signatureSize = 114;

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
    final ffiPublicKey = calloc<Uint8>(_keySize);
    final ffiPrivateKey = toUint8ListPointer(this.privateKey);

    _libdecaf.decaf_ed448_derive_public_key(ffiPublicKey, ffiPrivateKey);

    var publicKey = Uint8List.fromList(ffiPublicKey.asTypedList(_keySize));
    return Ed448PublicKey.fromBytes(publicKey);
  }

  /// Signs a message [message] and returns a signature.
  Uint8List sign(Uint8List message) {
    final ffiMessage = toUint8ListPointer(message);
    final publicKey = this.publicKey();
    final ffiPublicKey = toUint8ListPointer(publicKey.getPublicKey);
    final ffiPrivateKey = toUint8ListPointer(this.privateKey);
    final ffiSignature = malloc<Uint8>(_signatureSize);

    _libdecaf.decaf_ed448_sign(ffiSignature, ffiPrivateKey, ffiPublicKey, ffiMessage, message.length, 0, nullptr, 0);

    final signature = Uint8List.fromList(ffiSignature.asTypedList(_signatureSize));
    return signature;
  }

}