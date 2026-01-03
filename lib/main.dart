import 'package:classlog/core/features/auth/screens/login_screen.dart';
import 'package:classlog/core/theme/app_colors.dart';
import 'package:classlog/core/theme/theme_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // guardado URL, KEY
  runApp(const ProviderScope(
    child: ClassLogApp(),
  ));
}

class ClassLogApp extends StatelessWidget {
  const ClassLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ClassLog',
      theme: ThemeData(
        colorScheme: appColorScheme(), // custom color theme
        textTheme: appTextTheme(), // custom font theme
        appBarTheme: AppBarThemeData(
          centerTitle: true,
          backgroundColor: bgLightColor,
        ),
        scaffoldBackgroundColor: bgLightColor,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
