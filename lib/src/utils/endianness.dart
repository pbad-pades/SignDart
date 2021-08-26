import 'dart:typed_data';

Uint8List toLittleEndian(Uint8List value) {
  List<int> temp = value.reversed.toList();
  return Uint8List.fromList(temp);
}
