import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pro/bloc/connectvity/connectivity_bloc.dart';
import 'package:test_pro/bloc/connectvity/connectivity_state.dart';
import 'package:test_pro/cubit/currency_muti_state/currency_multi_cubit.dart';
import 'package:test_pro/data/models/currency_model.dart';

import '../../cubit/currency_muti_state/currency_multi_state.dart';

class CurrencyMultiStateScreen extends StatefulWidget {
  const CurrencyMultiStateScreen({super.key});

  @override
  State<CurrencyMultiStateScreen> createState() =>
      _CurrencyMultiStateScreenState();
}

class _CurrencyMultiStateScreenState extends State<CurrencyMultiStateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cubit Multi State Screen",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CurrenciesMultiStateCubit, CurrenciesMultiState>(
              builder: (BuildContext context, CurrenciesMultiState state) {
                if (state is CurrenciesErrorMultiState) {
                  return Center(child: Text(state.errorText));
                }

                if (state is CurrenciesSuccessMultiState) {
                  return ListView.builder(
                    itemCount: state.currencies.length,
                    itemBuilder: (BuildContext context, int index) {
                      CurrencyModel currencyModel = state.currencies[index];
                      return ListTile(
                        title: Text(
                          currencyModel.title,
                          style: const TextStyle(fontSize: 22),
                        ),
                        subtitle: Text(currencyModel.cbPrice,
                            style: const TextStyle(fontSize: 18)),
                        trailing: Text(currencyModel.code,
                            style: const TextStyle(fontSize: 16)),
                      );
                    },
                  );
                }
                if(state is CurrenciesLoadingMultiState){
                  const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            ),
          ),
          BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) {
              if (!state.hasInternet) {
                context.read<CurrenciesMultiStateCubit>().errorConnectInternet();
              } else {
                context.read<CurrenciesMultiStateCubit>().callCurrency();
              }
            },
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }
}