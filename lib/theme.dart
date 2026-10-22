
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color forestGreen = Color(0xFF153E35);
  static const Color deepGreen = Color(0xFF0F2F28);
  static const Color mediumGreen = Color(0xFF36745D);

  static const Color gold = Color(0xFFD6B16D);
  static const Color paleGold = Color(0xFFF4E8C9);

  static const Color background = Color(0xFFF7F5EF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF202820);
  static const Color secondaryText = Color(0xFF747A72);
  static const Color border = Color(0xFFE7E4DA);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF101814);
  static const Color darkSurface = Color(0xFF18251F);
  static const Color darkPrimaryText = Color(0xFFF2F4F0);
  static const Color darkSecondaryText = Color(0xFFB8C2BA);
  static const Color darkBorder = Color(0xFF30443A);
  static const Color darkSelectedAyah = Color(0xFF35452F);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      primaryColor: forestGreen,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: forestGreen,
        secondary: gold,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: deepGreen,
        onSurface: primaryText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: primaryText,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: border),
        ),
      ),
      bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: forestGreen,
        unselectedItemColor: secondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      primaryColor: mediumGreen,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF78B69A),
        secondary: gold,
        surface: darkSurface,
        onPrimary: Color(0xFF0F2F28),
        onSecondary: Color(0xFF202820),
        onSurface: darkPrimaryText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkPrimaryText,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: darkBorder),
        ),
      ),
      bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: gold,
        unselectedItemColor: darkSecondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
    );
  }
}
