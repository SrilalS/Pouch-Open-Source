import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/lib/utilities/validations.dart'; // Assuming the correct path

void main() {
  group('Validations', () {
    test('isValidPercentage returns true for valid percentage values', () {
      expect(Validations.isValidPercentage("0"), true);
      expect(Validations.isValidPercentage("50"), true);
      expect(Validations.isValidPercentage("100"), true);
      expect(Validations.isValidPercentage("0.0"), true);
      expect(Validations.isValidPercentage("50.5"), true);
      expect(Validations.isValidPercentage("99.99"), true);
    });

    test('isValidPercentage returns false for invalid percentage values', () {
      expect(Validations.isValidPercentage("-1"), false);
      expect(Validations.isValidPercentage("101"), false);
      expect(Validations.isValidPercentage("abc"), false);
      expect(Validations.isValidPercentage(""), false);
      expect(Validations.isValidPercentage(" "), false);
      expect(Validations.isValidPercentage("100.01"), false);
    });
  });
}
