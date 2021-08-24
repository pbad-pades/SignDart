import 'package:test/test.dart';
import 'package:dartffiedlibdecaf/dartffiedlibdecaf.dart';
import './testVector.dart';

void main() {
  group('Ed448', () {
    test('Test public key generation', () {
      for (var i = 0; i < edd448_privateKey_vector.length; i++) {
        var privateKey = Ed448PrivateKey.fromBytes(edd448_privateKey_vector[i]);
        var publicKeyToCheck = edd448_publicKey_vector[i];
        expect(publicKeyToCheck, privateKey.publicKey().getPublicKey);
      }
    });
    test('Test signing with Ed448', () {
      for (var i = 0; i < edd448_privateKey_vector.length; i++) {
        var message = message_vector[i];
        var privateKey = Ed448PrivateKey.fromBytes(edd448_privateKey_vector[i]);
        var signatureToCheck = edd448_signature_vector[i];

        var signature = privateKey.sign(message);

        expect(signatureToCheck, signature);
      }
    });

    test('Test verify with Ed448', () {
      for (var i = 0; i < edd448_privateKey_vector.length; i++) {
        var message = message_vector[i];
        var publicKeyToCheck = edd448_publicKey_vector[i];
        var signature = edd448_signature_vector[i];
        var publicKey = Ed448PublicKey.fromBytes(publicKeyToCheck);

        var isValid = publicKey.verify(signature, message);

        expect(isValid, true);
      }
    });

    test('Test random private keys', () {
      for (var i = 0; i < 1000; i++) {
        for (var message in message_vector) {
          var privateKey = Ed448PrivateKey.generate();
          var publicKey = privateKey.publicKey();

          var signature = privateKey.sign(message);

          var isValid = publicKey.verify(signature, message);

          expect(isValid, true);
        }
      }
    });
  });
}