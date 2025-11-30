import 'package:classlog/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme appTextTheme() {
  return TextTheme(
    displaySmall: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w500,
      letterSpacing: -1,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      letterSpacing: -1,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      letterSpacing: -1,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: -1,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: -1,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: -1,
    ),
    bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
    labelSmall: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400),
  );
}

ColorScheme appColorScheme() {
  return ColorScheme(
    brightness: Brightness.light,
    primary: mainColor,
    onPrimary: mainDarkColor,
    secondary: examColor,
    onSecondary: examStrongColor,
    tertiary: autoEvalColor,
    onTertiary: autoEvalStrongColor,
    error: pointRedColor,
    onError: pointRedColor,
    surface: bgColor,
    onSurface: textColor,
    outline: lineColor,
    shadow: shadowColor,
  );
}
