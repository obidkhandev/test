import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pro/bloc/currency_event.dart';
import 'package:test_pro/bloc/currency_state.dart';
import 'package:test_pro/data/remote/api_provider.dart';
import 'package:update_data/currency_model.dart';
import 'package:update_data/local_db.dart';
import 'package:update_data/network_response.dart';
import 'package:update_data/update_local_data.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrencyInitialState()) {
    on<GetCurrencyEvent>(_getCurrencies);
  }

  static List<CurrencyModel> localCurrencies = [];
  static bool updateData = true;

  Future<void> _getCurrencies(GetCurrencyEvent event, Emitter<CurrencyState> emit) async {
    await _getLocalData();
    emit(CurrencyLoadingState());
    NetworkResponse networkResponse = await ApiProvider.getCurrency();
    if (networkResponse.errorText.isEmpty) {
      emit(CurrencySuccessState(currencies: networkResponse.data as List<CurrencyModel>));
    }
    await _changeData();
  }

  Future<void> _getLocalData() async {
    NetworkResponse networkResponse = await LocalDatabase.getAllCurrency();
    if (networkResponse.errorText.isEmpty) {
      localCurrencies = networkResponse.data;
    }
  }

  Future<void> _changeData() async {
    await _getLocalData();
    if (localCurrencies.isEmpty) {
      localCurrencies = (state is CurrencySuccessState) ? (state as CurrencySuccessState).currencies : [];
      for (CurrencyModel currencyModel in localCurrencies) {
        await LocalDatabase.insertCurrency(currencyModel);
      }
    } else if (state is CurrencySuccessState && (state as CurrencySuccessState).currencies.isNotEmpty && updateData) {
      for (CurrencyModel currencyModelLocal in localCurrencies) {
        for (CurrencyModel currencyModel in (state as CurrencySuccessState).currencies) {
          if (currencyModelLocal.spotTheDifference(currencyModel: currencyModel)) {
            await updateLocalDB(currencyModel);
            break;
          }
        }
      }
      updateData = false;
    }
    emit(CurrencySuccessState(currencies: localCurrencies));
  }

  Future<void> errorConnectInternet() async {
    if (localCurrencies.isEmpty) {
      NetworkResponse networkResponse = await LocalDatabase.getAllCurrency();
      emit(CurrencySuccessState(currencies: networkResponse.data));
    } else {
      emit(CurrencySuccessState(currencies: localCurrencies));
    }
  }
}
