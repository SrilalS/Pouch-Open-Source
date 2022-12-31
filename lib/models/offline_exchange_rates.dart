import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:pouch/plugins/storage.dart';

@Entity()
class OfflineExchangeRates{
  @Id(assignable: true)
  int id = 1;
  String serializedRates; // rates from the API

  OfflineExchangeRates(this.serializedRates);

  Map getExchangeRates(){
    return Map<String, dynamic>.from(jsonDecode(serializedRates));
  }

  void updateRates(Map rates){
    serializedRates = jsonEncode(rates);
    save();
  }

  void save() {
    Storage.offlineExchangeRatesStore.put(this);
  }
}