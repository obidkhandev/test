import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:update_data/currency_model.dart';
import 'package:update_data/network_response.dart';

class ApiProvider {
  static Future<NetworkResponse> getCurrency() async {
    NetworkResponse networkResponse = NetworkResponse();

    http.Response response;

    try {
      response =
      await http.get(Uri.parse("https://nbu.uz/en/exchange-rates/json/"));

      if (response.statusCode == 200) {
        List<CurrencyModel> c = (jsonDecode(response.body) as List?)
            ?.map((e) => CurrencyModel.fromJson(e))
            .toList() ??
            [];
        networkResponse.data = c;
      } else {
        networkResponse.errorText = "Api error";
      }
    } catch (error) {
      networkResponse.errorText = "Error $error";
    }

    return networkResponse;
  }
}