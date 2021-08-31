import 'dart:io';
import 'dart:typed_data';

import 'package:signdart/signdart.dart';

main() async {
  var privateKeyBytes = await File('privKey448.txt').readAsBytes();
  var publicKeyBytes = await File('pubKey448.txt').readAsBytes();

  var message = Uint8List.fromList([0x03]);

  var ed448 = TwistedEdwardCurve.ed448();

  var privateKey1 = EdPrivateKey.generate(ed448);
  // or
  var privateKey = EdPrivateKey.fromBytes(privateKeyBytes, ed448);


  var signature = privateKey.sign(message);

  var publicKey1 = EdPublicKey.fromBytes(publicKeyBytes, ed448);
  //or
  var publicKey = privateKey.getPublicKey();
  print(signature);

  var isValid = publicKey.verify(message, signature);

  print(isValid ? 'Is valid' : 'Is not valid');
}
