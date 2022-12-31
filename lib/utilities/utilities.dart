import 'package:flutter/material.dart';
import 'package:pouch/models/exchange_rates.dart';
import 'package:pouch/models/subscription.dart';
import 'package:pouch/themes/text_themes.dart';
import 'package:intl/intl.dart';

class Utilities {
  static NumberFormat currencyFormat = NumberFormat("#,##0.00", "en_US");

  static String getTotalSubscriptionsValue(List<Subscription> subscriptions, String currencyCode) {
    double totalValue = 0.0;

    for (Subscription subscription in subscriptions) {
      double totalSubPrice = 0;
      if(subscription.type == 0) {
        totalSubPrice = subscription.price;
      } else {
        if(months[DateTime.now().month - 1] == subscription.month){
          totalSubPrice = subscription.price;
        } else {
          totalSubPrice = 0;
        }
      }
      if (subscription.isTaxFixed && totalSubPrice > 0) {
        totalSubPrice += subscription.tax;
      } else {
        totalSubPrice += (totalSubPrice * subscription.tax) / 100;
      }
      double currencyToUSD = ExchangeRates.convert(
        totalSubPrice,
        subscription.currency,
        currencyCode,
      );
      totalValue += currencyToUSD;
    }
    return currencyFormat.format(totalValue);
  }

  static String getSubscriptionTotalValue(Subscription subscription, String currencyCode) {
    double total = subscription.price;
    if (subscription.isTaxFixed) {
      total += subscription.tax;
    } else {
      total += (subscription.price * subscription.tax) / 100;
    }
    return currencyFormat.format(
        ExchangeRates.convert(total, subscription.currency, currencyCode));
  }

  static String getSubscriptionInfo(Subscription subscription) {
    String info =
        '${subscription.currency} ${Utilities.currencyFormat.format(subscription.price)}';
    if (subscription.isTaxFixed && subscription.tax > 0) {
      info +=
          ' + Tax of ${subscription.currency} ${Utilities.currencyFormat.format(subscription.tax)}';
    } else if(subscription.tax > 0) {
      info += ' + Tax of ${Utilities.currencyFormat.format(subscription.tax)}%';
    }
    return info;
  }

  static String getPaymentDayString(Subscription subscription) {
    if (subscription.type == 0) {
      return '${Utilities.ordinal(int.parse(subscription.date))} of Every Month';
    } else {
      return '${Utilities.ordinal(int.parse(subscription.date))} of ${subscription.month} Every Year';
    }
  }

  static Widget headerMaker(String header) {
    return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 16),
      Text(header, style: TextThemes.headingTwoW),
      const SizedBox(height: 8),
      const Divider(),
    ],
    );
  }

  static String ordinal(int number) {
    if (!(number >= 1 && number <= 31)) {
      throw Exception('Invalid number');
    }

    if (number >= 11 && number <= 13) {
      return '${number}th';
    }

    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  static List<String> dates = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31'
  ];

  static List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
}
