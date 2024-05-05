import 'package:flutter/material.dart';
import 'package:test_pro/map/screen/map_screen.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: false),
        home: MapPage()
    );
  }
}