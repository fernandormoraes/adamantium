class BindNotFound implements Exception {
  final String message;

  const BindNotFound(this.message);

  @override
  String toString() {
    return message;
  }
}

class BindAlreadyExists implements Exception {
  final String message;

  const BindAlreadyExists(this.message);

  @override
  String toString() {
    return message;
  }
}
