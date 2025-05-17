import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'layout/main_layout.dart';
import 'firebase_options.dart';
import 'shared/styles/colors.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if Firebase is already initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase already initialized: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Event Planner',
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.primaryDark,
              background: AppColors.background,
              surface: AppColors.white,
              onSurface: AppColors.text,
            ),
            scaffoldBackgroundColor: AppColors.background,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.text,
              titleTextStyle: TextStyle(
                fontSize: 20.0,
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
              shape: Border(
                bottom: BorderSide(color: AppColors.grey, width: 1.5),
              ),
            ),
            cardTheme: CardTheme(
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            listTileTheme: const ListTileThemeData(
              textColor: AppColors.text,
              iconColor: AppColors.primary,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              secondary: AppColors.primaryDark,
              background: Colors.grey[900]!,
              surface: Colors.grey[850]!,
              onSurface: Colors.white,
            ),
            scaffoldBackgroundColor: Colors.grey[900],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[850],
              foregroundColor: Colors.white,
              titleTextStyle: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              shape: Border(
                bottom: BorderSide(color: Colors.grey[700]!, width: 1.5),
              ),
            ),
            cardTheme: CardTheme(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            listTileTheme: ListTileThemeData(
              textColor: Colors.white,
              iconColor: AppColors.primary,
              tileColor: Colors.grey[850],
            ),
            dividerColor: Colors.grey[700],
            switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.primary;
                }
                return null;
              }),
              trackColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.primary.withOpacity(0.5);
                }
                return null;
              }),
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: const MainScaffold(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
