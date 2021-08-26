import 'package:test/test.dart';
import 'package:dartffiedlibdecaf/dartffiedlibdecaf.dart';
import './test_vector.dart';

void main() {
  group('Ed448', () {
    test('Test public key generation', () {
      for (var i = 0; i < edd448PrivateKeyVector.length; i++) {
        var privateKey = Ed448PrivateKey.fromBytes(edd448PrivateKeyVector[i]);
        var publicKeyToCheck = edd448PublicKeyVector[i];
        expect(publicKeyToCheck, privateKey.publicKey().getPublicKey);
      }
    });
    test('Test signing with Ed448', () {
      for (var i = 0; i < edd448PrivateKeyVector.length; i++) {
        var message = messageVector[i];
        var privateKey = Ed448PrivateKey.fromBytes(edd448PrivateKeyVector[i]);
        var signatureToCheck = edd448SignatureVector[i];

        var signature = privateKey.sign(message);

        expect(signatureToCheck, signature);
      }
    });

    test('Test verify with Ed448', () {
      for (var i = 0; i < edd448PrivateKeyVector.length; i++) {
        var message = messageVector[i];
        var publicKeyToCheck = edd448PublicKeyVector[i];
        var signature = edd448SignatureVector[i];
        var publicKey = Ed448PublicKey.fromBytes(publicKeyToCheck);

        var isValid = publicKey.verify(signature, message);

        expect(isValid, true);
      }
    });

    test('Test random private keys', () {
      for (var i = 0; i < 1000; i++) {
        for (var message in messageVector) {
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