import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/lib/utilities/utilities.dart'; // Assuming the correct path
import 'package:my_app/models/subscription.dart'; // Assuming the correct path
import 'package:my_app/models/exchange_rates.dart'; // Assuming the correct path
import 'package:intl/intl.dart';

void main() {
  group('Utilities', () {
    // Mock ExchangeRates for testing
    setUp(() {
      ExchangeRates.exchangeRates = {
        "USD": 1.0,
        "EUR": 0.85,
        "LKR": 200.0,
      };
    });

    test('getTotalSubscriptionsValue calculates total value correctly', () {
      final subscriptions = [
        Subscription(price: 10, currency: "USD", tax: 0, isTaxFixed: false, type: 0, date: "1", month: "January"),
        Subscription(price: 20, currency: "EUR", tax: 10, isTaxFixed: true, type: 0, date: "1", month: "January"),
      ];
      expect(Utilities.getTotalSubscriptionsValue(subscriptions, "USD"), "37.00");

      final subscriptions2 = [
        Subscription(price: 100, currency: "LKR", tax: 5, isTaxFixed: false, type: 0, date: "1", month: "January"),
      ];
      expect(Utilities.getTotalSubscriptionsValue(subscriptions2, "USD"), "0.53");
    });

    test('getSubscriptionTotalValue calculates total value correctly', () {
      final subscription1 = Subscription(price: 10, currency: "USD", tax: 0, isTaxFixed: false, type: 0, date: "1", month: "January");
      expect(Utilities.getSubscriptionTotalValue(subscription1, "USD"), "10.00");

      final subscription2 = Subscription(price: 20, currency: "EUR", tax: 10, isTaxFixed: true, type: 0, date: "1", month: "January");
      expect(Utilities.getSubscriptionTotalValue(subscription2, "USD"), "35.29");

      final subscription3 = Subscription(price: 100, currency: "LKR", tax: 5, isTaxFixed: false, type: 0, date: "1", month: "January");
      expect(Utilities.getSubscriptionTotalValue(subscription3, "USD"), "0.53");
    });

    test('getSubscriptionInfo returns correct subscription information', () {
      final subscription1 = Subscription(price: 10, currency: "USD", tax: 0, isTaxFixed: false, type: 0, date: "1", month: "January");
      expect(Utilities.getSubscriptionInfo(subscription1), "USD 10.00");

      final subscription2 = Subscription(price: 20, currency: "EUR", tax: 10, isTaxFixed: true, type: 0, date: "1", month: "January");
      expect(Utilities.getSubscriptionInfo(subscription2), "EUR 20.00 + Tax of EUR 10.00");

      final subscription3 = Subscription(price: 100, currency: "LKR", tax: 5, isTaxFixed: false, type: 0, date: "1", month: "January");
      expect(Utilities.getSubscriptionInfo(subscription3), "LKR 100.00 + Tax of 5.00%");
    });

    test('getPaymentDayString returns correct payment day string', () {
      final subscription1 = Subscription(type: 0, date: "5", month: "January", price: 10, currency: "USD", tax: 0, isTaxFixed: false);
      expect(Utilities.getPaymentDayString(subscription1), "5th of Every Month");

      final subscription2 = Subscription(type: 1, date: "15", month: "February", price: 10, currency: "USD", tax: 0, isTaxFixed: false);
      expect(Utilities.getPaymentDayString(subscription2), "15th of February Every Year");
    });

    test('ordinal returns correct ordinal string for valid numbers', () {
      expect(Utilities.ordinal(1), "1st");
      expect(Utilities.ordinal(2), "2nd");
      expect(Utilities.ordinal(3), "3rd");
      expect(Utilities.ordinal(4), "4th");
      expect(Utilities.ordinal(11), "11th");
      expect(Utilities.ordinal(21), "21st");
      expect(Utilities.ordinal(22), "22nd");
      expect(Utilities.ordinal(23), "23rd");
      expect(Utilities.ordinal(24), "24th");
    });

    test('ordinal throws exception for invalid numbers', () {
      expect(() => Utilities.ordinal(0), throwsException);
      expect(() => Utilities.ordinal(32), throwsException);
    });
  });
}
