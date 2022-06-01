class DatabaseExceptions implements Exception {
  String? message;
  Exception? exception;
  DatabaseExceptions({
    this.message,
    this.exception,
  });

  @override
  String toString() =>
      'DatabaseExceptions(message: $message, exception: $exception)';
}
