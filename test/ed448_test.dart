import 'dart:typed_data';

import 'package:signdart/signdart.dart';
import 'package:test/test.dart';

import 'test_vector.dart';

main() {
  group('Ed448', () {
    late Curve ed448;

    setUp(() {
      ed448 = TwistedEdwardCurve.ed448();
    });

    group('Test Ed448 from RFC 8032', () {
      late Uint8List message;
      late Uint8List privateKeyBytes;
      late Uint8List publicKeyBytes;
      late Uint8List signatureBytes;

      late EdPrivateKey privateKey;
      late EdPublicKey publicKey;
      late Uint8List signature;

      for (var i = 0; i < ed448PrivateKeyVector.length; i++) {
        setUp(() {
          message = messageVector[i];
          publicKeyBytes = ed448PublicKeyVector[i];
          privateKeyBytes = ed448PrivateKeyVector[i];
          signatureBytes = ed448SignatureVector[i];
        });

        group('Test $i', () {
          test('Test public and private keys', () {
            privateKey = EdPrivateKey.fromBytes(privateKeyBytes, ed448);
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
                ed448PublicKeyVector[
                    (i + 1) % (ed448PublicKeyVector.length - 1)],
                ed448);
            bool isSignatureValid =
                differentPublicKey.verify(message, signature);
            expect(isSignatureValid, false);
          });

          test('Verifying fails when using different message', () {
            Uint8List differentMessage =
                Uint8List.fromList([(i + 1) % (messageVector.length - 1)]);
            bool isSignatureValid =
                publicKey.verify(differentMessage, signature);
            expect(isSignatureValid, false);
          });

          test('Verifying fails when using different signature', () {
            Uint8List differentSignature = ed448SignatureVector[
                (i + 1) % (ed448SignatureVector.length - 1)];
            bool isSignatureValid =
                publicKey.verify(message, differentSignature);
            expect(isSignatureValid, false,
                reason: ed448SignatureVector.length.toString());
          });
        });
      }
    });

    test('Test random private keys', () {
      int keySize = 57;
      int signatureSize = keySize * 2;

      for (var i = 0; i < 100; i++) {
        for (var j = 0; j < messageVector.length; j++) {
          Uint8List message = messageVector[j];
          EdPrivateKey privateKey = EdPrivateKey.generate(ed448);
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
