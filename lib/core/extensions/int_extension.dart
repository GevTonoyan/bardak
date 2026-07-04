extension IntExtension on int {
  /// Formats the integer using dot as thousands separator.
  String get toDotThousands {
    final isNegative = this < 0;
    final digits = abs().toString();

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      buffer.write(digits[i]);

      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write('.');
      }
    }

    return isNegative ? '-$buffer' : buffer.toString();
  }
}
