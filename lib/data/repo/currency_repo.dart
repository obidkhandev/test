
import 'package:test_pro/data/remote/api_provider.dart';
import 'package:test_pro/data/remote/network_response.dart';

class CurrencyRepository {
  Future<NetworkResponse> getCurrencies() async {
    return ApiProvider.getCurrency();
  }
}