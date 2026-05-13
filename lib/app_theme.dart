/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane
 */
import 'package:flutter/material.dart';

class AppTheme {
  // Primary Palette
  static const primary = Color.fromARGB(255, 90, 213, 235); // Indigo
  static const primaryLight = Color(0xFFE0E7FF);
  static const primaryDark = Color.fromARGB(255, 120, 117, 195);

  // Supporting Colors
  static const secondary = Color(0xFF06B6D4); // Cyan
  static const accent = Color(0xFF8B5CF6); // Violet

  // Backgrounds
  static const background = Color.fromARGB(255, 253, 250, 252);
  static const surface = Color.fromARGB(255, 59, 203, 228);

  // Borders & States
  static const border = Color(0xFFE2E8F0);
  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF22C55E);

  // Text
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);

  // Inputs
  static const inputFill = Color(0xFFF8FAFC);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Times New Roman',
    scaffoldBackgroundColor: background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: surface,
      background: background,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 49, 207, 221),
      foregroundColor: Color.fromARGB(255, 0, 0, 0),
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontFamily: 'Times New Roman',
        fontSize: 25,
        fontWeight: FontWeight.w800,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 14, 14, 14),
      selectedItemColor: Color.fromARGB(255, 88, 206, 246),
      unselectedItemColor: Color.fromARGB(255, 247, 247, 247),
      type: BottomNavigationBarType.fixed,
      elevation: 4,
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: border),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 1.6),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 1.7),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 1.7),
      ),

      labelStyle: const TextStyle(color: textSecondary, fontSize: 14),

      errorStyle: const TextStyle(color: error, fontSize: 12),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: const Color.fromARGB(255, 12, 12, 12),
        minimumSize: const Size(double.infinity, 50),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        textStyle: const TextStyle(
          fontFamily: 'Times New Roman',
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),

        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Color.fromARGB(255, 18, 18, 18)),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
