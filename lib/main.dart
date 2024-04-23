import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pro/data/repo/file_repo.dart';
import 'package:test_pro/screens/file_manager_screen.dart';
import 'package:test_pro/screens/on_board_screen.dart';
import 'package:test_pro/services/file_manager_sevice.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FileManagerService();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => FileRepository()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: false),
        home: OnBoardScreen(),
      ),
    );
  }
}