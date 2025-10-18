import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitt/theme/colors.dart';
import 'package:splitt/theme/fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final IColors colors = LightColors();
    final IFonts fonts = LightFonts();
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: colors.primaryColor,
      scaffoldBackgroundColor: colors.backgroundColor,
      hintColor: colors.hintColor,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      fontFamily: 'Poppins',
      textTheme: GoogleFonts.poppinsTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: fonts.heading2.copyWith(
          color: colors.hintColor,
        ),
        contentPadding: const EdgeInsets.only(top: 8),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.primaryColor,
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(colors.primaryColor),
      ),
    );
  }
}
