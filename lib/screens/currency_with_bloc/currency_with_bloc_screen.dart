import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pro/bloc/connectvity/connectivity_bloc.dart';
import 'package:test_pro/bloc/connectvity/connectivity_state.dart';
import 'package:test_pro/bloc/currency_bloc.dart';
import 'package:test_pro/bloc/currency_event.dart';
import 'package:test_pro/bloc/currency_state.dart';
import 'package:test_pro/data/models/currency_model.dart';

import '../../cubit/currency_muti_state/currency_multi_state.dart';

class CurrencyWithBloc extends StatefulWidget {
  const CurrencyWithBloc({super.key});

  @override
  State<CurrencyWithBloc> createState() =>
      _CurrencyWithBlocState();
}

class _CurrencyWithBlocState extends State<CurrencyWithBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Currency With Bloc",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (BuildContext context, CurrencyState state) {
                if (state is CurrencyErrorState) {
                  return Center(child: Text(state.errorText));
                }
                if (state is CurrencySuccessState) {
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
                context.read<CurrencyBloc>().errorConnectInternet();
              } else {
                context.read<CurrencyBloc>().add(GetCurrencyEvent());
              }
            },
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }
}