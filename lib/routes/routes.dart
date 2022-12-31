import 'package:get/get.dart';
import 'package:pouch/views/settings_view.dart';
import 'package:pouch/views/subcriptions_view.dart';
import 'package:pouch/views/upsert_subscription_view.dart';

class Routes {
  static List<GetPage> routes = [
    GetPage(
      name: '/',
      page: () => const SubscriptionsView(),
    ),
    GetPage(
      name: '/upsert-subscription',
      page: () => const UpsertSubcriptionView(),
    ),
    GetPage(
      name: '/settings',
      page: () => const SettingsView(),
    ),
  ];
}