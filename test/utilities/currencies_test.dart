import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/lib/utilities/currencies.dart'; // Assuming the correct path

void main() {
  group('Currencies', () {
    test('getCurrency returns correct currency for existing currency codes', () {
      expect(Currencies.getCurrency("USD"), {"cc": "USD", "symbol": "US\$", "name": "United States dollar"});
      expect(Currencies.getCurrency("EUR"), {"cc": "EUR", "symbol": "\u20ac", "name": "European Euro"});
      expect(Currencies.getCurrency("LKR"), {"cc": "LKR", "symbol": "Rs", "name": "Sri Lankan rupee"});
    });

    test('getCurrency throws StateError for non-existent currency codes', () {
      expect(() => Currencies.getCurrency("XYZ"), throwsA(isA<StateError>()));
    });
  });
}
