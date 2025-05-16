هimport 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'layout/main_layout.dart';
import 'shared/network/remote/firebase_options.dart';
import 'shared/styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Planner',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          titleTextStyle: TextStyle(fontSize: 20.0),
          shape: Border(bottom: BorderSide(color: AppColors.grey, width: 1.5)),
        ),
      ),
      home: const MainScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
