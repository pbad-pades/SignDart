import 'package:signdart/signdart.dart';
import 'package:test/test.dart';

import 'test_vector.dart';

main() {
  Curve ed521 = TwistedEdwardCurve.ed521();

  group('Ed521', () {
    test('Test Ed521', () {
      for (var i = 0; i < edd521PrivateKeyVector.length; i++) {
        var privateKey = EdPrivateKey.fromBytes(edd521PrivateKeyVector[i], ed521);
        var publicKey = privateKey.getPublicKey();
        var publicKeyToCheck = edd521PublicKeyVector[i];

        expect(publicKeyToCheck, publicKey.publicKey);

        var message = messageVector[i];
        var signature = privateKey.sign(message);
        var signatureToCheck = edd521SignatureVector[i];

        expect(signatureToCheck, signature);

        var isSignatureValid = publicKey.verify(message, signature);

        expect(isSignatureValid, true);
      }
    });

    test('Test random private keys', () {
      int keySize = 66;
      int signatureSize = keySize * 2;

      for (var i = 0; i < 100; i++) {
        for (var message in messageVector) {
          var privateKey = EdPrivateKey.generate(ed521);
          var publicKey = privateKey.getPublicKey();

          expect(privateKey.privateKey.length, keySize);
          expect(publicKey.publicKey.length, keySize);

          var signature = privateKey.sign(message);

          expect(signature.length, signatureSize);

          var isValid = publicKey.verify(message, signature);

          expect(isValid, true);
        }
      }
    });
  });
}
