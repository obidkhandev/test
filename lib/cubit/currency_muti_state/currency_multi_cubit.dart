import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pro/cubit/currency_muti_state/currency_multi_state.dart';
import 'package:update_data/currency_model.dart';
import 'package:update_data/local_db.dart';
import 'package:update_data/update_local_data.dart';
import 'package:test_pro/data/remote/api_provider.dart';
import 'package:update_data/network_response.dart';

class CurrenciesMultiStateCubit extends Cubit<CurrenciesMultiState> {
  CurrenciesMultiStateCubit() : super(CurrenciesInitialMultiState()) {}

  static List<CurrencyModel> localCurrencies = [];
  static bool updateData = true;

  Future<void> callCurrency() async {
    getLocalData();
    emit(CurrenciesLoadingMultiState());
    NetworkResponse networkResponse = await ApiProvider.getCurrency();
    if (networkResponse.errorText.isEmpty) {
      emit(CurrenciesSuccessMultiState(currencies: networkResponse.data));
    }
    changeData();
  }

  Future<void> getLocalData() async {
    NetworkResponse networkResponse =
        await LocalDatabase.getAllCurrency();
    if (networkResponse.errorText.isEmpty) {
      localCurrencies = networkResponse.data;
    }
  }

  Future<void> changeData() async {
    await getLocalData();
    if (localCurrencies.isEmpty) {
      localCurrencies = (state is CurrenciesSuccessMultiState)
          ? (state as CurrenciesSuccessMultiState).currencies
          : [];
      for (CurrencyModel currencyModel in localCurrencies) {
        await LocalDatabase.insertCurrency(currencyModel);
      }
    } else if (state is CurrenciesSuccessMultiState &&
        (state as CurrenciesSuccessMultiState).currencies.isNotEmpty &&
        updateData) {
      for (CurrencyModel currencyModelLocal in localCurrencies) {
        for (CurrencyModel currencyModel
            in (state as CurrenciesSuccessMultiState).currencies) {
          if (currencyModelLocal.spotTheDifference(
              currencyModel: currencyModel)) {
            await updateLocalDB(currencyModel);
            break;
          }
        }
      }
      updateData = false;
    }
    emit(CurrenciesSuccessMultiState(currencies: localCurrencies));
  }

  errorConnectInternet() async {
    if (localCurrencies.isEmpty) {
      NetworkResponse networkResponse =
          await LocalDatabase.getAllCurrency();
      emit(CurrenciesSuccessMultiState(currencies: networkResponse.data));
    } else {
      emit(CurrenciesSuccessMultiState(currencies: localCurrencies));
    }
  }
}
