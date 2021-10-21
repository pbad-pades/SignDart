import 'dart:typed_data';

import 'package:signdart/signdart.dart';
import 'package:test/test.dart';

import 'test_vector.dart';

main() {
  group('Ed521', () {
    late Curve ed521;

    setUp(() {
      ed521 = TwistedEdwardCurve.ed521();
    });

    group('Test Ed521', () {
      late Uint8List message;
      late Uint8List privateKeyBytes;
      late Uint8List publicKeyBytes;
      late Uint8List signatureBytes;

      late EdPrivateKey privateKey;
      late EdPublicKey publicKey;
      late Uint8List signature;

      for (var i = 0; i < ed521PrivateKeyVector.length; i++) {
        setUp(() {
          message = messageVector[i];
          publicKeyBytes = ed521PublicKeyVector[i];
          privateKeyBytes = ed521PrivateKeyVector[i];
          signatureBytes = ed521SignatureVector[i];
        });

        group('Test $i', () {
          test('Test public and private keys', () {
            privateKey = EdPrivateKey.fromBytes(privateKeyBytes, ed521);
            publicKey = privateKey.getPublicKey();
            expect(publicKeyBytes, publicKey.publicKey);
          });

          test('Test sign', () {
            signature = privateKey.sign(message);
            expect(signatureBytes, signature);
          });

          test('Test verification', () {
            bool isSignatureValid = publicKey.verify(message, signature);
            expect(isSignatureValid, true);
          });

          test('Verifying fails when using different public key', () {
            EdPublicKey differentPublicKey = EdPublicKey.fromBytes(
                ed521PublicKeyVector[
                    (i + 1) % (ed521PublicKeyVector.length - 1)],
                ed521);
            bool isSignatureValid =
                differentPublicKey.verify(message, signature);
            expect(isSignatureValid, false);
          });
        });
      }
    });

    test('Test random private keys', () {
      int keySize = 66;
      int signatureSize = keySize * 2;

      for (var i = 0; i < 100; i++) {
        for (var j = 0; j < messageVector.length; j++) {
          Uint8List message = messageVector[j];
          EdPrivateKey privateKey = EdPrivateKey.generate(ed521);
          EdPublicKey publicKey = privateKey.getPublicKey();

          expect(privateKey.privateKey.length, keySize);
          expect(publicKey.publicKey.length, keySize);

          Uint8List signature = privateKey.sign(message);

          expect(signature.length, signatureSize);

          bool isValid = publicKey.verify(message, signature);

          expect(isValid, true);

          Uint8List differentMessage =
              messageVector[(j + 1) % (messageVector.length - 1)];

          isValid = publicKey.verify(differentMessage, signature);

          expect(isValid, false);

          Uint8List differentSignature = privateKey.sign(differentMessage);

          isValid = publicKey.verify(message, differentSignature);

          expect(isValid, false);
        }
      }
    });
  });
}
