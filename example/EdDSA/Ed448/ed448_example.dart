import 'dart:io';
import 'dart:typed_data';

import 'package:signdart/signdart.dart';

main() async {
  Uint8List privateKeyBytes = await File('privKey448.txt').readAsBytes();
  Uint8List publicKeyBytes = await File('pubKey448.txt').readAsBytes();

  Uint8List message = Uint8List.fromList([0x03]);

  TwistedEdwardCurve ed448 = TwistedEdwardCurve.ed448();

  EdPrivateKey privateKey = EdPrivateKey.generate(ed448);
  // or
  privateKey = EdPrivateKey.fromBytes(privateKeyBytes, ed448);

  Uint8List signature = privateKey.sign(message);

  EdPublicKey publicKey = EdPublicKey.fromBytes(publicKeyBytes, ed448);
  //or
  publicKey = privateKey.getPublicKey();

  bool isValid = publicKey.verify(message, signature);

  print(isValid ? 'Is valid' : 'Is not valid');
}
