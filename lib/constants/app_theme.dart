import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2D3E50);
  static const Color secondaryColor = Color(0xFF3498DB);
  static const Color accentColor = Color(0xFF1ABC9C);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color warningColor = Color(0xFFF39C12);
  static const Color infoColor = Color(0xFF3498DB);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color darkBackgroundColor = Color(0xFF1A2530);
  static const Color cardColor = Colors.white;
  static const Color darkCardColor = Color(0xFF2C3E50);
  static const Color textColor = Color(0xFF2C3E50);
  static const Color darkTextColor = Color(0xFFECF0F1);
  static const Color subtleTextColor = Color(0xFF7F8C8D);
  static const Color darkSubtleTextColor = Color(0xFFBDC3C7);

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      background: backgroundColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: const CardTheme(
      color: cardColor,
      elevation: 2,
      margin: EdgeInsets.all(8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.poppins(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.poppins(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: textColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: textColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      background: darkBackgroundColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    cardTheme: const CardTheme(
      color: darkCardColor,
      elevation: 2,
      margin: EdgeInsets.all(8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkCardColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.poppins(
        color: darkTextColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        color: darkTextColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        color: darkTextColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: darkTextColor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: darkTextColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.poppins(
        color: darkTextColor,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: darkTextColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: darkTextColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: secondaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}
