import 'dart:ffi';
import '../libdecaf_generated_bindings.dart' show Libdecaf;
import '../utils/path.dart';


final String _libPath = locatePath();

class FFILibDecaf extends Libdecaf {
  FFILibDecaf() : super(DynamicLibrary.open(_libPath));
}