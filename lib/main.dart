import 'package:classlog/features/auth/widgets/auth_wrapper.dart';
import 'package:classlog/app/theme/app_colors.dart';
import 'package:classlog/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences before app starts
  await SharedPreferences.getInstance();

  await dotenv.load(fileName: ".env"); // guardado URL, KEY

  runApp(const ProviderScope(
    child: ClassLogApp(),
  ));
}

class ClassLogApp extends StatelessWidget {
  const ClassLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(builder: (context) {
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
        builder: (context, child) {
          return Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: 600), // Max width for web page
              child: child!,
            ),
          );
        },
        home: const AuthWrapper(),
      );
    });
  }
}
