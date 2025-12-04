import 'package:classlog/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme appTextTheme() {
  return TextTheme(
    displaySmall: GoogleFonts.lexend(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    headlineLarge: GoogleFonts.lexend(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    headlineMedium: GoogleFonts.lexend(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    headlineSmall: GoogleFonts.lexend(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    titleLarge: GoogleFonts.lexend(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    titleMedium: GoogleFonts.lexend(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    titleSmall: GoogleFonts.lexend(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    bodyLarge: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: GoogleFonts.lexend(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w400),
    labelMedium: GoogleFonts.lexend(fontSize: 12, fontWeight: FontWeight.w400),
    labelSmall: GoogleFonts.lexend(fontSize: 10, fontWeight: FontWeight.w400),
  );
}

ColorScheme appColorScheme() {
  return ColorScheme(
    brightness: Brightness.light,
    primary: mainColor,
    onPrimary: mainLightColor,
    secondary: secondaryColor,
    onSecondary: subSecondaryColor,
    error: dangercolor,
    onError: subDangercolor,
    surface: textSecondaryColor,
    onSurface: textPrimaryColor,
    outline: lineColor,
    shadow: shadowColor,
  );
}
