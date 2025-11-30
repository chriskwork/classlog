import 'package:classlog/screens/login_screen.dart';
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
      ),
      home: LoginScreen(),
    );
  }
}
