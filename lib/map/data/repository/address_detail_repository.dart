import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_pro/map/data/models/address_detail_model.dart';
import 'package:test_pro/map/data/models/app_lat_long.dart';


class AddressDetailRepository {
  Future<AddressDetailModel?> getAddressDetail(AppLatLong latLong) async {
    String mapApiKey = "cc569340-9587-47a2-8f66-f030205e2692";
    try {
      Map<String, String> queryParams = {
        'apikey': mapApiKey,
        'geocode': "${latLong.long},${latLong.lat}",
        'lang': 'uz',
        'format': 'json',
        'results': '1'
      };
      Dio yandexDio = Dio();
      var response = await yandexDio.get(
        "https://geocode-maps.yandex.ru/1.x/",
        queryParameters: queryParams,
      );
      return AddressDetailModel.fromJson(response.data);
    } catch (e) {
      debugPrint("Error $e");
    }
    return null;
  }
}