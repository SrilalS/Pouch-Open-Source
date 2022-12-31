import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pouch/models/subscription.dart';
import 'package:pouch/utilities/currencies.dart';
import 'package:pouch/utilities/utilities.dart';

class UpsertSubcriptionViewController {
  static TextEditingController nameController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static TextEditingController taxController = TextEditingController(text: '0');

  static RxBool isTaxFixed = true.obs;
  static RxMap currency =
      {"cc": "LKR", "symbol": "Rs", "name": "Sri Lankan rupee"}.obs;

  static RxInt type = 0.obs;
  static Rx<Color> color = Colors.blue.obs;

  static RxString paymentDate = '1'.obs;
  static RxString paymentMonth = 'January'.obs;

  static void resetFields() {
    nameController.text = '';
    priceController.text = '';
    taxController.text = '0';
    isTaxFixed.value = true;
    currency.value = <String, String>{
      "cc": "LKR",
      "symbol": "Rs",
      "name": "Sri Lankan rupee"
    };
    type.value = 0;
    color.value = Colors.blue;
    paymentDate.value = '1';
    paymentMonth.value = 'January';
  }

  static void upsertSubscription() {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        taxController.text.isEmpty) {
          Get.snackbar(
      'Missing Fields',
      'Please fill all the fields',
      backgroundColor: Colors.white,
      colorText: Colors.black,
      shouldIconPulse: false,
      margin: const EdgeInsets.all(8),
      icon: const Icon(Icons.warning, color: Colors.red),
    );
    } else {
      Subscription subscription = Subscription(
        nameController.text,
        type.value,
        paymentDate.value,
        paymentMonth.value,
        double.parse(priceController.text),
        color.value.value,
        currency['cc'],
        isTaxFixed.value,
        double.parse(taxController.text),
      );
      if (Get.arguments != null) {
        subscription.id = Get.arguments.id;
      }
      subscription.save();
      resetFields();
      Get.back();
    }
  }

  static void upsertCheck(arguments) {
    resetFields();
    if (arguments != null) {
      Subscription subscription = arguments;
      nameController.text = subscription.name;
      priceController.text = subscription.price.toString();
      taxController.text = subscription.tax.toString();
      isTaxFixed.value = subscription.isTaxFixed;
      currency.value = Currencies.currencies
          .firstWhere((element) => element['cc'] == subscription.currency);
      type.value = subscription.type;

      paymentDate.value = subscription.date;
      paymentMonth.value = subscription.month;

      List<Color> primaryColors = Colors.primaries;
      color.value = primaryColors
          .firstWhere((element) => element.value == subscription.color);
    }
  }

  static void showTaxType() {
    Get.bottomSheet(Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Utilities.headerMaker('Tax Type'),
          Obx(() => ListTile(
                title: const Text('Fixed'),
                tileColor: isTaxFixed.value ? Colors.blue : null,
                trailing: isTaxFixed.value
                    ? const Icon(
                        Icons.check,
                      )
                    : const SizedBox(),
                onTap: () {
                  isTaxFixed.value = true;
                  Get.back();
                },
              )),
          Obx(() => ListTile(
                title: const Text('Percentage'),
                tileColor: !isTaxFixed.value ? Colors.blue : null,
                trailing: !isTaxFixed.value
                    ? const Icon(
                        Icons.check,
                      )
                    : const SizedBox(),
                onTap: () {
                  isTaxFixed.value = false;
                  Get.back();
                },
              )),
          const SizedBox(height: 8),
        ],
      ),
    ));
  }

  static void showCurrencyType() {
    Get.bottomSheet(Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Utilities.headerMaker('Currency'),
          Expanded(
            child: ListView.builder(
              itemCount: Currencies.currencies.length,
              itemBuilder: (context, index) {
                return Obx(() => Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(Currencies.currencies[index]['name']),
                        tileColor:
                            currency['cc'] == Currencies.currencies[index]['cc']
                                ? Colors.blue
                                : null,
                        trailing:
                            currency['cc'] == Currencies.currencies[index]['cc']
                                ? const Icon(Icons.check)
                                : const SizedBox(),
                        onTap: () {
                          currency.value = Currencies.currencies[index];
                          Get.back();
                        },
                      ),
                    ));
              },
            ),
          )
        ],
      ),
    ));
  }

  static void showColor() {
    Get.bottomSheet(Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Utilities.headerMaker('Color'),
          Expanded(
            child: ListView.builder(
              itemCount: Colors.primaries.length,
              itemBuilder: (context, index) {
                return Obx(() => Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(Colors.primaries[index]
                            .toString()
                            .split('(')[2]
                            .replaceAll(')', '')),
                        tileColor: color.value == Colors.primaries[index]
                            ? Colors.blue
                            : null,
                        leading: CircleAvatar(
                          backgroundColor: Colors.primaries[index],
                        ),
                        trailing: color.value == Colors.primaries[index]
                            ? const Icon(Icons.check)
                            : const SizedBox(),
                        onTap: () {
                          color.value = Colors.primaries[index];
                          Get.back();
                        },
                      ),
                    ));
              },
            ),
          )
        ],
      ),
    ));
  }

  static void showPeriod() {
    Get.bottomSheet(Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Utilities.headerMaker('Payment Period'),
          Obx(() => ListTile(
                title: const Text('Monthly'),
                tileColor: type.value == 0 ? Colors.blue : null,
                trailing: type.value == 0
                    ? const Icon(
                        Icons.check,
                      )
                    : const SizedBox(),
                onTap: () {
                  type.value = 0;
                  Get.back();
                },
              )),
          Obx(() => ListTile(
                title: const Text('Yearly'),
                tileColor: type.value == 1 ? Colors.blue : null,
                trailing: type.value == 1
                    ? const Icon(
                        Icons.check,
                      )
                    : const SizedBox(),
                onTap: () {
                  type.value = 1;
                  Get.back();
                },
              )),
          const SizedBox(height: 8),
        ],
      ),
    ));
  }

  static void showDates() {
    Get.bottomSheet(Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Utilities.headerMaker('Payment Date of Month'),
          Expanded(
            child: ListView.builder(
              itemCount: Utilities.dates.length,
              itemBuilder: (context, index) {
                return Obx(() => Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(Utilities.dates[index]),
                        tileColor: paymentDate.value == Utilities.dates[index]
                            ? Colors.blue
                            : null,
                        trailing: paymentDate.value == Utilities.dates[index]
                            ? const Icon(Icons.check)
                            : const SizedBox(),
                        onTap: () {
                          paymentDate.value = Utilities.dates[index];
                          Get.back();
                        },
                      ),
                    ));
              },
            ),
          )
        ],
      ),
    ));
  }

  static void showMonths() {
    Get.bottomSheet(Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Utilities.headerMaker('Payment Month'),
          Expanded(
            child: ListView.builder(
              itemCount: Utilities.months.length,
              itemBuilder: (context, index) {
                return Obx(() => Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(Utilities.months[index]),
                        tileColor: paymentMonth.value == Utilities.months[index]
                            ? Colors.blue
                            : null,
                        trailing: paymentMonth.value == Utilities.months[index]
                            ? const Icon(Icons.check)
                            : const SizedBox(),
                        onTap: () {
                          paymentMonth.value = Utilities.months[index];
                          Get.back();
                          showDates();
                        },
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    ));
  }
}
