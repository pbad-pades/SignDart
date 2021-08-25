import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

Pointer<Uint8> toUint8ListPointer(Uint8List bytes) {
    final ffiPointer = calloc<Uint8>(bytes.length);
    ffiPointer.asTypedList(bytes.length).setAll(0, bytes);
    return ffiPointer;
  }