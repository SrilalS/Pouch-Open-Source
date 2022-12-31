import 'package:pouch/models/offline_exchange_rates.dart';
import 'package:pouch/models/pouch_settings.dart';
import 'package:pouch/models/subscription.dart';
import 'package:pouch/plugins/object_box.dart';
import 'package:pouch/objectbox-models/objectbox.g.dart';
class Storage {
  static late ObjectBox objectBox;
  static late Box<Subscription> subStore;
  static late Box<PouchSettings> settingsStore;
  static late Box<OfflineExchangeRates> offlineExchangeRatesStore;

  static Future<void> init() async {
    objectBox = await ObjectBox.create();
    subStore = objectBox.store.box<Subscription>();
    settingsStore = objectBox.store.box<PouchSettings>();
    offlineExchangeRatesStore = objectBox.store.box<OfflineExchangeRates>();
  }


}