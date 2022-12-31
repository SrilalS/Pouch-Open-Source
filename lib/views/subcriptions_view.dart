import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pouch/controllers/subscriptions_view_controller.dart';

class SubscriptionsView extends StatelessWidget {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {

    SubscriptionsViewController.initialize();

    return Scaffold(
      floatingActionButton: SubscriptionsViewController.fAB(),
      body: Obx(() => SubscriptionsViewController.isLoading.value
          ? const LinearProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.transparent,
          )
          : Column(
                children: [
                  SubscriptionsViewController.subscriptionOverViewCard(),
                  const Divider(height: 1,thickness: 1),
                  Expanded(
                    child: Obx(() => ListView.builder(
                        itemCount:
                            SubscriptionsViewController.subscriptions.length,
                        itemBuilder: (context, index) {
                          return SubscriptionsViewController.subscriptionItemCard(index);
                        },
                      )),
                  )
                ],
              )),
    );
  }
}
