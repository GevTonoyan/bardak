import 'package:bardak/core/extensions/int_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('toDotThousands', () {
    test('numbers under a thousand are unchanged', () {
      expect(0.toDotThousands, '0');
      expect(7.toDotThousands, '7');
      expect(999.toDotThousands, '999');
    });

    test('separates thousands with dots', () {
      expect(1000.toDotThousands, '1.000');
      expect(12345.toDotThousands, '12.345');
      expect(1234567.toDotThousands, '1.234.567');
    });

    test('keeps the minus sign in front', () {
      expect((-1000).toDotThousands, '-1.000');
      expect((-999).toDotThousands, '-999');
    });
  });
}
