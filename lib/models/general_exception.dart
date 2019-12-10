class GeneralException implements Exception {
  final String message;

  const GeneralException({this.message});

  @override
  String toString() {
    return message;
  }

  String errorMessage() {
    return message;
  }
}