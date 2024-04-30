import 'package:flutter/material.dart';
import 'package:test_pro/screens/currency_multi_state/currency_multi_state_screen.dart';
import 'package:test_pro/screens/currency_single/currency_single_state_screen.dart';
import 'package:test_pro/screens/currency_with_bloc/currency_with_bloc_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CurrencyWithBloc()));
              },
              child: const Text("Currency with Bloc",
                  style: TextStyle(color: Colors.black,fontSize: 32)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CurrencyMultiStateScreen()),
                );
              },
              child: const Text("Currency multi state",
                  style: TextStyle(color: Colors.black,fontSize: 32)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CurrencySingleStateScreen()),
                );
              },
              child: const Text(
                "Currency single state",
                style: TextStyle(color: Colors.black,fontSize: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
