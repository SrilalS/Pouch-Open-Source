import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:pouch/models/subscription.dart';
import 'package:pouch/plugins/storage.dart';
import 'package:pouch/themes/text_themes.dart';
import 'package:pouch/utilities/currencies.dart';
import 'package:pouch/utilities/utilities.dart';

class SubscriptionsViewController {
  static RxBool isLoading = true.obs;
  static RxList<Subscription> subscriptions = <Subscription>[].obs;
  static RxMap currency = {}.obs;
  static RxString totalValue = ''.obs;

  static void initialize() {
    currency.value = Currencies.currencies[0];
    getSubscriptions();
  }

  static void getSubscriptions() {
    isLoading.value = true;
    subscriptions.value = Storage.subStore.getAll();
    totalValue.value =
        Utilities.getTotalSubscriptionsValue(subscriptions, currency['cc']);
    isLoading.value = false;
  }

  static void showDeleteConfirmation(Subscription subscription) async {
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
          Utilities.headerMaker('Confirm Delete'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    subscription.delete();
                    getSubscriptions();
                    Get.back();
                  },
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 16),
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
                          
                          getSubscriptions();
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

  static void showSubscriptionItemOptions(Subscription subscription) {
    Get.bottomSheet(
      Card(
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
        Utilities.headerMaker('Options'),
        ListTile(
          title: const Text('Edit'),
          trailing: const Icon(Icons.edit),
          onTap: () {
            Get.back();
            Get.toNamed('/upsert-subscription', arguments: subscription)
                ?.then((value) => {getSubscriptions()});
           
          },
        ),
        ListTile(
          title: const Text('Delete'),
          trailing: const Icon(Icons.delete),
          onTap: () {
            Get.close(1);
            showDeleteConfirmation(subscription);
          },
        ),
        const SizedBox(height: 8)
      ],
      ),
    )
    
    );
  }

  static FloatingActionButton fAB() {
    return FloatingActionButton(
        onPressed: () => Get.toNamed('/upsert-subscription')
            ?.then((value) => {getSubscriptions()}),
        backgroundColor: Colors.transparent,
        shape: const CircleBorder(),
        child: GlassContainer.frostedGlass(
          height: 64,
          width: 64,
          shape: BoxShape.circle,
          frostedOpacity: 0.04,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ));
  }

  static Widget subscriptionItemCard(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 150,
      child: Card(
          color: Color(subscriptions[index].color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: GlassContainer.clearGlass(
            width: Get.width,
            height: 256,
            blur: 0,
            color: Colors.transparent,
            borderWidth: 0,
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subscriptions[index].name,
                    style: TextThemes.headingThreeW,
                  ),
                  IconButton(
                    onPressed: () =>
                        showSubscriptionItemOptions(subscriptions[index]),
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                  )
                ],
              ),
              Obx(() => Text(
                  currency['cc'] +
                      ' ' +
                      Utilities.getSubscriptionTotalValue(
                          subscriptions[index], currency['cc']),
                  style: TextThemes.headingTwoW)),
              Text(Utilities.getSubscriptionInfo(subscriptions[index])),
              Text(Utilities.getPaymentDayString(subscriptions[index]))
            ]),
          )),
    );
  }

  static Widget subscriptionOverViewCard() {
    return GlassContainer.frostedGlass(
      width: Get.width,
      height: 132,
      borderRadius: BorderRadius.circular(12),
      elevation: 16,
      frostedOpacity: 0.04,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('This Month\'s Cost', style: TextThemes.headingTwoW),
              TextButton(
                  onPressed: () => showCurrencyType(),
                  child: Row(
                    children: [
                      Obx(
                        () => Text(currency['cc'],
                            style: TextThemes.headingThreeW),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.change_circle,
                        color: Colors.white,
                      )
                    ],
                  )),
            ],
          ),
          Obx(() => Text(currency['cc'] + ' ' + totalValue.value,
              style: TextThemes.headingZeroW))
        ],
      ),
    );
  }
}
