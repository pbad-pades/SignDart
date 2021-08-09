class SignatureSizeException implements Exception {
  String _message = 'The size of the signature is wrong! It should be: ';
  int _correctSize;

  SignatureSizeException(this._correctSize);

  @override
  String toString() {
    return _message + _correctSize.toString();
  }
}