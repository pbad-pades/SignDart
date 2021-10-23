class SignatureSizeException implements Exception {
  final String _message = 'The size of the signature is wrong! It should be: ';
  final int _correctSize;

  SignatureSizeException(this._correctSize);

  @override
  String toString() {
    return _message + _correctSize.toString();
  }
}
