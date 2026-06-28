/// Application-wide logging contract.
///
/// Call sites depend only on this interface, so the backing implementation
/// Can change without touching any caller.
abstract interface class AppLogger {
  /// Verbose diagnostics useful only while developing.
  void debug(String message);

  /// Notable but expected events.
  void info(String message);

  /// Recoverable problems worth attention.
  void warning(String message, {Object? error, StackTrace? stackTrace});

  /// Errors and exceptions (the main hook for crash reporting).
  void error(String message, {Object? error, StackTrace? stackTrace});
}
