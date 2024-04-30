import 'package:update_data/currency_model.dart';


abstract class CurrencyState {}

class CurrencyInitialState extends CurrencyState {}

class CurrencyLoadingState extends CurrencyState {}

class CurrencySuccessState extends CurrencyState {
  CurrencySuccessState({required this.currencies});

  final List<CurrencyModel> currencies;
}

class CurrencyErrorState extends CurrencyState {
  CurrencyErrorState({required this.errorText});

  final String errorText;
}