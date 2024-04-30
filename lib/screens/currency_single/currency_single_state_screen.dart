import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pro/bloc/connectvity/connectivity_bloc.dart';
import 'package:test_pro/bloc/connectvity/connectivity_state.dart';
import 'package:test_pro/cubit/currency_single_state/currency_single_state_cubit.dart';
import 'package:test_pro/cubit/currency_single_state/currency_single_state_state.dart';
import 'package:test_pro/data/models/currency_model.dart';

class CurrencySingleStateScreen extends StatefulWidget {
  const CurrencySingleStateScreen({super.key});

  @override
  State<CurrencySingleStateScreen> createState() =>
      _CurrencySingleStateScreenState();
}

class _CurrencySingleStateScreenState extends State<CurrencySingleStateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cubit Single State Screen",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CurrencyCubitSingl, CurrencyCubitSinglState>(
              builder: (BuildContext context, CurrencyCubitSinglState state) {
                if (state.errorText.isNotEmpty) {
                  return Center(child: Text(state.errorText));
                }

                if (state.errorText.isEmpty && !state.loading) {
                  return ListView.builder(
                    itemCount: state.currencyModels.length,
                    itemBuilder: (BuildContext context, int index) {
                      CurrencyModel currencyModel = state.currencyModels[index];
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

                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            ),
          ),
          BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) {
              if (!state.hasInternet) {
                context.read<CurrencyCubitSingl>().errorConnectInternet();
              } else {
                context.read<CurrencyCubitSingl>().callCurrency();
              }
            },
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }
}