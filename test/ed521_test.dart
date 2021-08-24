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
  });
}