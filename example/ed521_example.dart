import 'dart:io';
import 'dart:typed_data';

import 'package:dartffiedlibdecaf/dartffiedlibdecaf.dart';

main() async {
  var privateKeyBytes = await File('privKey521.txt').readAsBytes();
  var publicKeyBytes = await File('pubKey521.txt').readAsBytes();

  var message = Uint8List.fromList([0x03]);

  var ed521 = TwistedEdwardCurve.ed521();

  var privateKey = EdPrivateKey.generate(ed521);
  // or
  privateKey = EdPrivateKey.fromBytes(privateKeyBytes, ed521);

  var signature = privateKey.sign(message);

  var publicKey = EdPublicKey.fromBytes(publicKeyBytes, ed521);
  //or
  publicKey = privateKey.getPublicKey();

  var isValid = publicKey.verify(message, signature);

  print(isValid ? 'Is valid' : 'Is not valid');
}
