import 'dart:typed_data';

void printHex(Uint8List array) {
  String hex = "";

  for (var int in array) {
    String str = int.toRadixString(16).toUpperCase();

    if (str.length == 2) {
      hex += str;
    } else {
      hex += "0" + str;
    }
  }
  print(hex);
}
