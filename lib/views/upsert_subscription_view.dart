import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pouch/controllers/upsert_subscription_view_controller.dart';
import 'package:pouch/utilities/utilities.dart';

class UpsertSubcriptionView extends StatelessWidget {
  const UpsertSubcriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    UpsertSubcriptionViewController.upsertCheck(Get.arguments);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          elevation: 0,
          title: const Text('Add Subscription'),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            IconButton(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check),
                  SizedBox(width: 4),
                  Text('Save'),
                  SizedBox(width: 4),
                ],
              ),
              onPressed: ()=> UpsertSubcriptionViewController.upsertSubscription(),
            )
          ]
          ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 16, right: 16, top: 16, bottom: 0
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: UpsertSubcriptionViewController.nameController,
              
              decoration: const InputDecoration(
                labelText: 'Subscription Name'
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Obx((() => TextField(
                          controller: UpsertSubcriptionViewController.priceController,
                          keyboardType:
                              const TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            labelText: 'Price',
                            prefix: Text(UpsertSubcriptionViewController.currency['cc'] + ' '),
                          ),
                        )))),
                const SizedBox(width: 16),
                SizedBox(
                  height: 64,
                  width: Get.width / 4,
                  child: ElevatedButton(
                      onPressed: () {
                        UpsertSubcriptionViewController.showCurrencyType();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Text(UpsertSubcriptionViewController.currency['cc'])),
                          const SizedBox(width: 4),
                          const Icon(Icons.change_circle)
                        ],
                      )),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Obx((() => TextField(
                        controller: UpsertSubcriptionViewController.taxController,
                        keyboardType:
                            const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          labelText: 'Tax',
                          prefix: UpsertSubcriptionViewController.isTaxFixed.value
                              ? Text(UpsertSubcriptionViewController.currency['cc'] + ' ')
                              : const SizedBox(),
                          suffix: !UpsertSubcriptionViewController.isTaxFixed.value
                              ? const Text('%')
                              : const SizedBox(),
                        ),
                      ))),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 64,
                  width: Get.width / 4,
                  child: ElevatedButton(
                      onPressed: () {
                        UpsertSubcriptionViewController.showTaxType();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Text(UpsertSubcriptionViewController.isTaxFixed.value ? 'Fixed' : '%')),
                          const SizedBox(width: 4),
                          const Icon(Icons.change_circle)
                        ],
                      )),
                )
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 64,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UpsertSubcriptionViewController.color.value,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              UpsertSubcriptionViewController.showColor();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('Color'),
                                SizedBox(width: 4),
                                Icon(Icons.change_circle)
                              ],
                            )),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 64,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              UpsertSubcriptionViewController.showPeriod();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(UpsertSubcriptionViewController.type.value == 0
                                    ? 'Monthly'
                                    : 'Yearly'),
                                const SizedBox(width: 4),
                                const Icon(Icons.change_circle)
                              ],
                            )),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 64,
                    child: Obx(() => ElevatedButton(
                        onPressed: () {
                          if (UpsertSubcriptionViewController.type.value == 0) {
                            UpsertSubcriptionViewController.showDates();
                          } else {
                            UpsertSubcriptionViewController.showMonths();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UpsertSubcriptionViewController.type.value == 0
                                ? Text(
                                    '${Utilities.ordinal(int.parse(UpsertSubcriptionViewController.paymentDate.value))} of Every Month')
                                : Text(
                                    '${Utilities.ordinal(int.parse(UpsertSubcriptionViewController.paymentDate.value))} of ${UpsertSubcriptionViewController.paymentMonth.value} Every Year'),
                            const SizedBox(width: 4),
                            const Icon(Icons.change_circle)
                          ],
                        ))),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () async {
                        UpsertSubcriptionViewController.upsertSubscription();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check),
                          SizedBox(width: 4),
                          Text('Save'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
