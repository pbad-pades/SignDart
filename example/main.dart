import 'dart:io';
import 'dart:typed_data';

import 'package:dartffiedlibdecaf/dartffiedlibdecaf.dart';

Future<void> main() async {
  var privateKeyBytes = await File('./priv.txt').readAsBytes();
  var publicKeyBytes = await File('./pub.txt').readAsBytes();

  var message = 'Hello World!';
  var messageBytes = Uint8List.fromList(message.codeUnits);

  var privateKey = Ed448PrivateKey.generate();
  // or
  privateKey = Ed448PrivateKey.fromBytes(privateKeyBytes);

  var signature = privateKey.sign(messageBytes);  

  var publicKey = privateKey.publicKey();
  // or 
  publicKey = Ed448PublicKey.fromBytes(publicKeyBytes);

  var isValid = publicKey.verify(signature, messageBytes);
  
  print(isValid ? 'Is Valid' : 'Is NOT Valid');
}