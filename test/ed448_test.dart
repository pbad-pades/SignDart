import 'dart:typed_data';

import 'package:signdart/signdart.dart';
import 'package:test/test.dart';

import 'test_vector.dart';

main() {
  Curve ed448 = TwistedEdwardCurve.ed448();

  group('Ed448', () {
    test('Test Ed448', () {
      for (var i = 0; i < ed448PrivateKeyVector.length; i++) {
        EdPrivateKey privateKey = EdPrivateKey.fromBytes(ed448PrivateKeyVector[i], ed448);
        EdPublicKey publicKey = privateKey.getPublicKey();
        Uint8List publicKeyToCheck = ed448PublicKeyVector[i];

        expect(publicKeyToCheck, publicKey.publicKey);

        Uint8List message = messageVector[i];
        Uint8List signature = privateKey.sign(message);
        Uint8List signatureToCheck = ed448SignatureVector[i];

        expect(signatureToCheck, signature);

        bool isSignatureValid = publicKey.verify(message, signature);

        expect(isSignatureValid, true);
      }
    });

    test('Test random private keys', () {
      int keySize = 57;
      int signatureSize = keySize * 2;

      for (var i = 0; i < 100; i++) {
        for (var message in messageVector) {
          EdPrivateKey privateKey = EdPrivateKey.generate(ed448);
          EdPublicKey publicKey = privateKey.getPublicKey();

          expect(privateKey.privateKey.length, keySize);
          expect(publicKey.publicKey.length, keySize);

          Uint8List signature = privateKey.sign(message);

          expect(signature.length, signatureSize);

          bool isValid = publicKey.verify(message, signature);

          expect(isValid, true);
        }
      }
    });
  });
}
