/// Thrown when a class has not yet been initialized.
class InitializationException implements Exception {
  /// Creates a new [InitializationException].
  InitializationException(this.message);

  /// The exception message.
  final String message;

  @override
  String toString() => 'InitializationException: $message';
}
