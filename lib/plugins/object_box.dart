import 'package:pouch/objectbox-models/objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  Store store;
  
  ObjectBox._create(this.store);
  


  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }
}