class KeySizeException implements Exception {
  final String _message = 'The size of the key is wrong! It should be: ';
  final int _correctSize;

  KeySizeException(this._correctSize);

  @override
  String toString() {
    return _message + _correctSize.toString();
  }
}
