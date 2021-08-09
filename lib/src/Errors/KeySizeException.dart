class KeySizeException implements Exception {
  String _message = 'The size of the key is wrong! It should be: ';
  int _correctSize;

  KeySizeException(this._correctSize);

  @override
  String toString() {
    return _message + _correctSize.toString();
  }
}