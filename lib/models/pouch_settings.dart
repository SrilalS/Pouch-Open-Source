import 'package:objectbox/objectbox.dart';
import 'package:pouch/plugins/storage.dart';

@Entity()
class PouchSettings{
  @Id()
  int id = 0;

  String currency; // currency of the subscription. uses ISO 4217. eg: USD, EUR, INR

  PouchSettings(this.currency);

  void save() {
    Storage.settingsStore.put(this);
  }
}