import 'package:dartffiedlibdecaf/dartffiedlibdecaf.dart';
import 'package:test/test.dart';

import 'test_vector.dart';

main() {
  group('Ed521', () {

    test('Test public key generation', () {
      var ed521 = TwistedEdwardCurve.ed521();

      for (var i = 0; i < edd521PrivateKeyVector.length; i++) {
        var privateKey = EdPrivateKey.fromBytes(edd521PrivateKeyVector[i], ed521);
        var publicKeyToCheck = edd521PublicKeyVector[i];
        expect(publicKeyToCheck, privateKey.getPublicKey().publicKey);
      }
    });

    test('Test signing with Ed521', () {
      var ed521 = TwistedEdwardCurve.ed521();

      for (var i = 0; i < edd521SignatureVector.length; i++) {
        var message = messageVector[i];
        var privateKey = EdPrivateKey.fromBytes(edd521PrivateKeyVector[0], ed521);
        var signatureToCheck = edd521SignatureVector[i];

        var signature = privateKey.sign(message);

        expect(signatureToCheck, signature);
      }
    });

  });
}