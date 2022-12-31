import 'package:objectbox/objectbox.dart';
import 'package:pouch/plugins/storage.dart';

@Entity()
class Subscription {
  @Id()
  int id = 0;

  String name; // name of the subscription service

  int type; // 0 = monthly, 1 = yearly

  String date; // date of the subscription

  String month; // month of the subscription

  double price; // price of the subscription in selected currency

  int color; // color of the subscription in interger format

  String currency; // currency of the subscription. uses ISO 4217. eg: USD, EUR, INR

  bool isTaxFixed; // is the tax fixed or percentage

  double tax; // tax of the subscription

  Subscription(
    this.name,
    this.type,
    this.date,
    this.month,
    this.price,
    this.color,
    this.currency,
    this.isTaxFixed,
    this.tax
  );



  void save() {
    Storage.subStore.put(this);
  }

  void delete(){
    Storage.subStore.remove(id);
  }

  Subscription.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        date = json['date'],
        month = json['month'],
        price = json['price'],
        color = json['color'],
        currency = json['currency'],
        isTaxFixed = json['isTaxFixed'],
        tax = json['tax'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'date': date,
        'month': month,
        'price': price,
        'color': color,
        'currency': currency,
        'isTaxFixed': isTaxFixed,
        'tax': tax,
      };
}
