// import 'package:classlog/screens/login_screen.dart';
import 'package:classlog/screens/login_screen.dart';
import 'package:classlog/theme/colors.dart';
// import 'package:classlog/screens/register_screen.dart';
import 'package:classlog/theme/theme_style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ClassLogApp());
}

class ClassLogApp extends StatelessWidget {
  const ClassLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ClassLog',
      theme: ThemeData(
          colorScheme: appColorScheme(),
          textTheme: appTextTheme(),
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
          ))),
      home: LoginScreen(),
    );
  }
}
