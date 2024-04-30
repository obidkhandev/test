import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pro/bloc/connectvity/connectivity_bloc.dart';
import 'package:test_pro/bloc/connectvity/connectivity_event.dart';
import 'package:test_pro/bloc/currency_bloc.dart';
import 'package:test_pro/bloc/currency_event.dart';
import 'package:test_pro/cubit/currency_muti_state/currency_multi_cubit.dart';
import 'package:test_pro/cubit/currency_single_state/currency_single_state_cubit.dart';
import 'package:test_pro/data/repo/currency_repo.dart';
import 'package:test_pro/screens/home/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => CurrencyRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CurrencyBloc()..add(GetCurrencyEvent())),
          BlocProvider(
              create: (_) => ConnectivityBloc()..add(CheckConnectivity())),
          BlocProvider(create: (_) => CurrencyCubitSingl()..callCurrency()),
          BlocProvider(
              create: (_) => CurrenciesMultiStateCubit()..callCurrency()),
        ],
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: const HomeScreen(),
    );
  }
}