import 'package:pouch/plugins/http_client.dart';
import 'package:pouch/plugins/client_response.dart';


class ExchangeRates {

  static Map rates = {
    'usd':1.0,
  };

  static Future updateRates() async{
    ClientResponse response = await HttpClient.updateExchangeRates();
    if(response.status != 200){
    }
    rates = response.data['usd'];
    return true;
  }

  static double convert(double amount, String currencyID, String targetCurrencyID){
    double inUSD = amount/rates[currencyID.toLowerCase()];
    double inTargetCurrency = inUSD * rates[targetCurrencyID.toLowerCase()];
    return inTargetCurrency;
  }

  
}