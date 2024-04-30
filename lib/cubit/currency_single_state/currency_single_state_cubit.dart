import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pro/cubit/currency_single_state/currency_single_state_state.dart';
import 'package:update_data/currency_model.dart';
import 'package:update_data/local_db.dart';
import 'package:update_data/update_local_data.dart';
import 'package:test_pro/data/remote/api_provider.dart';
import 'package:update_data/network_response.dart';

class CurrencyCubitSingl extends Cubit<CurrencyCubitSinglState> {
  CurrencyCubitSingl()
      : super(
    CurrencyCubitSinglState(
      loading: false,
      errorText: '',
      currencyModels: [],
    ),
  );

  static List<CurrencyModel> localCurrencies = [];
  static bool updateData = true;

  Future<void> callCurrency() async {
    getLocalData();
    emit(state.copyWith(loading: true));
    NetworkResponse networkResponse = await ApiProvider.getCurrency();
    if (networkResponse.errorText.isEmpty) {
      emit(state.copyWith(
          loading: false,
          currencyModels: networkResponse.data as List<CurrencyModel>));
    }
    changeData();
  }

  Future<void> getLocalData() async {
    NetworkResponse networkResponse =
    await LocalDatabase.getAllQrScannerModels();
    if (networkResponse.errorText.isEmpty) {
      localCurrencies = networkResponse.data;
    }
  }

  Future<void> changeData() async {
    if (localCurrencies.isEmpty) {
      localCurrencies = state.currencyModels;
      for (CurrencyModel currencyModel in localCurrencies) {
        await LocalDatabase.insertQrScannerModel(currencyModel);
      }
    }
    if (state.currencyModels.isNotEmpty) {
      if (updateData) {
        if (localCurrencies.isEmpty) {
          NetworkResponse networkResponse =
          await LocalDatabase.getAllQrScannerModels();
          localCurrencies = networkResponse.data;
        }
        List<CurrencyModel> c = state.currencyModels;
        for (CurrencyModel currencyModelLocal in localCurrencies) {
          for (CurrencyModel currencyModel in c) {
            if (currencyModelLocal.spotTheDifference(
                currencyModel: currencyModel)) {
             await updateLocalDB(currencyModel);
              break;
            }
          }
        }
        updateData = false;
      }
    }
    if (state.currencyModels.isEmpty) {
      if (localCurrencies.isEmpty) {
        NetworkResponse networkResponse =
        await LocalDatabase.getAllQrScannerModels();
        localCurrencies = networkResponse.data;
      }

      emit(state.copyWith(
          currencyModels: localCurrencies, loading: false, errorText: ""));
    }
  }

  errorConnectInternet() async {
    if (localCurrencies.isEmpty) {
      NetworkResponse networkResponse =
      await LocalDatabase.getAllQrScannerModels();
      emit(state.copyWith(
        currencyModels: networkResponse.data,
        loading: false,
        errorText: "",
      ));
    } else {
      emit(state.copyWith(
        currencyModels: localCurrencies,
        loading: false,
        errorText: "",
      ));
    }
  }
}