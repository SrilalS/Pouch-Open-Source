import 'package:flutter_test/flutter_test.dart';
import 'package:project/utilities/validations.dart'; // Assuming your project structure

void main() {
  group('isValidPercentage', () {
    test('returns true for valid percentages', () {
      expect(Validations.isValidPercentage("0"), true);
      expect(Validations.isValidPercentage("50"), true);
      expect(Validations.isValidPercentage("100"), true);
      expect(Validations.isValidPercentage("0.0"), true);
      expect(Validations.isValidPercentage("50.5"), true);
      expect(Validations.isValidPercentage("100.0"), true);
    });

    test('returns false for invalid percentages', () {
      expect(Validations.isValidPercentage("-1"), false);
      expect(Validations.isValidPercentage("101"), false);
      expect(Validations.isValidPercentage("abc"), false);
      expect(Validations.isValidPercentage(""), false);
    });
  });
}
