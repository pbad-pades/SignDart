import 'dart:io';
import 'dart:typed_data';

import 'package:sign_dart/sign_dart.dart';

main() async {
  Uint8List privateKeyBytes = await File('privKey521.txt').readAsBytes();
  Uint8List publicKeyBytes = await File('pubKey521.txt').readAsBytes();

  Uint8List message = Uint8List.fromList([0x03]);

  TwistedEdwardCurve ed521 = TwistedEdwardCurve.ed521();

  EdPrivateKey privateKey = EdPrivateKey.generate(ed521);
  // or
  privateKey = EdPrivateKey.fromBytes(privateKeyBytes, ed521);

  Uint8List signature = privateKey.sign(message);

  EdPublicKey publicKey = EdPublicKey.fromBytes(publicKeyBytes, ed521);
  //or
  publicKey = privateKey.getPublicKey();

  bool isValid = publicKey.verify(message, signature);

  print(isValid ? 'Is valid' : 'Is not valid');
}
