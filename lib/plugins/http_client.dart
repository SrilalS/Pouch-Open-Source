import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pouch/models/offline_exchange_rates.dart';
import 'package:pouch/plugins/client_response.dart';
import 'package:pouch/plugins/storage.dart';

class HttpClient {
  static Dio dio = Dio();
  static late OfflineExchangeRates offlineExchangeRates;

  static Map<String, dynamic> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "",
  };

  HttpClient() {
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.options.headers = headers;
  }

  // Post Request Method
  static Future post(String url, Map data) async {
    try {
      return await dio.post(url, data: data);
    } on DioError catch (e) {
      return e.response;
    }
  }

  // Get Request Method
  static Future get(String url) async {
    try {
      return await dio.get(url);
    } on DioError catch (e) {
      return e.response;
    }
  }

  // File Upload Method
  /*static Future fileUpload(String url, XFile file, Map metadata) async {
    try {
      FormData form = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: file.name),
        "metadata": jsonEncode(metadata),
      });
      return await dio.post(url, data: form);
    } on DioError catch (e) {
      return e.response;
    }
  }*/

  static Future<ClientResponse> updateExchangeRates() async {
    var response = await get(
        "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/usd.json");

    if (response != null) {
      if(response.statusCode == 200){
        offlineExchangeRates = OfflineExchangeRates(jsonEncode(response.data['usd']));
        offlineExchangeRates.save();
        return ClientResponse(response.statusCode, response.data);
      } else {
        offlineExchangeRates = Storage.offlineExchangeRatesStore.get(1)!;
        return ClientResponse(response.statusCode, {'usd': offlineExchangeRates.getExchangeRates()});
      }
    } else {
      offlineExchangeRates = Storage.offlineExchangeRatesStore.get(1)!;
      return ClientResponse(400, {'usd': offlineExchangeRates.getExchangeRates()});
    }
  }
}

HttpClient httpClient = HttpClient();
