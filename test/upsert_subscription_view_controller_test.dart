import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pouch/controllers/upsert_subscription_view_controller.dart';
import 'package:pouch/models/subscription.dart';
import 'package:pouch/utilities/currencies.dart';
import 'package:pouch/utilities/utilities.dart';
import 'package:pouch/services/storage.dart';
import 'package:mockito/mockito.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late UpsertSubcriptionViewController controller;
  late MockStorage mockStorage;

  setUp(() {
    mockStorage = MockStorage();
    Get.put(Storage()); // Register the mock storage
    controller = UpsertSubcriptionViewController();
  });

  tearDown(() {
    Get.reset();
  });

  group('upsertSubscription', () {
    test('creates a new subscription with valid inputs', () {
      // Set valid input values
      UpsertSubcriptionViewController.nameController.text = 'Test Subscription';
      UpsertSubcriptionViewController.priceController.text = '10.0';
      UpsertSubcriptionViewController.taxController.text = '1.0';
      UpsertSubcriptionViewController.isTaxFixed.value = true;
      UpsertSubcriptionViewController.currency.value = Currencies.currencies.first;
      UpsertSubcriptionViewController.type.value = 0;
      UpsertSubcriptionViewController.color.value = Colors.blue;
      UpsertSubcriptionViewController.paymentDate.value = '15';
      UpsertSubcriptionViewController.paymentMonth.value = 'March';

      // Call the function to be tested
      UpsertSubcriptionViewController.upsertSubscription();

      // Assert that a new subscription is created and saved
      // You might need to adjust this part based on how your data is stored/accessed
      // For example, if subscriptions are stored in a list, you can check the list size
      // or verify the properties of the newly added subscription.
      // Since we are mocking the storage, we can verify that save was called
      verify(mockStorage.saveSubscription(any)).called(1);

      // Assert that fields are reset
      expect(UpsertSubcriptionViewController.nameController.text, '');
      expect(UpsertSubcriptionViewController.priceController.text, '');
      expect(UpsertSubcriptionViewController.taxController.text, '0');
      // ... other fields
    });

    test('updates an existing subscription with valid inputs', () {
      // Create a subscription to update
      final subscription = Subscription(
        'Old Name',
        0,
        '1',
        'January',
        10.0,
        Colors.blue.value,
        'USD',
        true,
        0.0,
      )..id = 'some_id';

      // Navigate with arguments to simulate updating an existing subscription
      Get.toNamed('/upsert_subscription', arguments: subscription);
      UpsertSubcriptionViewController.upsertCheck(Get.arguments);

      // Set new input values
      UpsertSubcriptionViewController.nameController.text = 'Updated Subscription';
      UpsertSubcriptionViewController.priceController.text = '20.0';
      UpsertSubcriptionViewController.taxController.text = '2.0';

      // Call the function to be tested
      UpsertSubcriptionViewController.upsertSubscription();

      // Assert that the subscription is updated
      // Similar to the create test, you might need to adjust assertions based on your data handling.
      verify(mockStorage.updateSubscription(any)).called(1);

      // Assert that fields are reset
      expect(UpsertSubcriptionViewController.nameController.text, '');
      // ...
    });

    test('handles missing required fields', () {
      // Set missing input values
      UpsertSubcriptionViewController.nameController.text = '';
      UpsertSubcriptionViewController.priceController.text = '';
      UpsertSubcriptionViewController.taxController.text = '';

      // Call the function to be tested
      UpsertSubcriptionViewController.upsertSubscription();

      // Assert that a snackbar is shown (you might need to adapt this based on how your snackbar is implemented)
      expect(Get.isSnackbarOpen, true);

      // You can also assert that no subscription is created/updated
      verifyNever(mockStorage.saveSubscription(any));
      verifyNever(mockStorage.updateSubscription(any));
    });
  });
}
