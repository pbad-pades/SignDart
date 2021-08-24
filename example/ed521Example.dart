import 'dart:io';

import 'package:dartffiedlibdecaf/dartffiedlibdecaf.dart';

main() async {
  var privateKeyBytes = await File('./privKey521.txt').readAsBytes();
  var publicKeyBytes = await File('./pubKey521.txt').readAsBytes();

  var ed521 = TwistedEdwardCurve.Ed521();

  var privateKey = EdPrivateKey.generate(ed521);
  // or
  privateKey = EdPrivateKey.fromBytes(privateKeyBytes, ed521);

  var publicKey = EdPublicKey.fromBytes(publicKeyBytes, ed521);
  //or
  publicKey = privateKey.getPublicKey();

  print(publicKey.publicKey);
}