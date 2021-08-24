import 'package:dartffiedlibdecaf/dartffiedlibdecaf.dart';
import 'package:test/test.dart';

import 'testVector.dart';

main() {
  group('Ed521', () {

    test('Test public key generation', () {
      var ed521 = TwistedEdwardCurve.Ed521();

      for (var i = 0; i < edd521_privateKey_vector.length; i++) {
        var privateKey = EdPrivateKey.fromBytes(edd521_privateKey_vector[i], ed521);
        var publicKeyToCheck = edd521_publicKey_vector[i];
        expect(publicKeyToCheck, privateKey.getPublicKey().publicKey);
      }
    });

    test('Test signing with Ed521', () {
      var ed521 = TwistedEdwardCurve.Ed521();

      for (var i = 0; i < edd521_signature_vector.length; i++) {
        var message = message_vector[i];
        var privateKey = EdPrivateKey.fromBytes(edd521_privateKey_vector[0], ed521);
        var signatureToCheck = edd521_signature_vector[i];

        var signature = privateKey.sign(message);

        expect(signatureToCheck, signature);
      }
    });

  });
}