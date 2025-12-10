import 'package:flutter/material.dart';

/// Application theme configuration with warm, earthy tones
class AppTheme {
  // Color Palette - Warm Earthy Tones
  static const Color primaryBrown = Color(0xFF8B6F47);
  static const Color lightBrown = Color(0xFFD4A574);
  static const Color darkBrown = Color(0xFF5C4A2F);
  static const Color cream = Color(0xFFF5E6D3);
  static const Color softGreen = Color(0xFF9CAF88);
  static const Color paleGreen = Color(0xFFD4E5C9);
  static const Color warmWhite = Color(0xFFFFFBF5);
  static const Color textDark = Color(0xFF2C2416);
  static const Color textGrey = Color(0xFF6B5D51);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryBrown,
        primaryContainer: lightBrown,
        secondary: softGreen,
        secondaryContainer: paleGreen,
        surface: warmWhite,
        surfaceContainerHighest: cream,
        error: const Color(0xFFB3261E),
        onPrimary: Colors.white,
        onSecondary: textDark,
        onSurface: textDark,
        onError: Colors.white,
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: warmWhite,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: warmWhite,
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBrown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBrown,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightBrown.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBrown, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB3261E)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: cream,
        selectedColor: softGreen,
        labelStyle: const TextStyle(color: textDark),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: warmWhite,
        selectedItemColor: primaryBrown,
        unselectedItemColor: textGrey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: softGreen,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textDark),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textDark),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textDark),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textDark),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textDark),
        bodyLarge: TextStyle(fontSize: 16, color: textDark),
        bodyMedium: TextStyle(fontSize: 14, color: textDark),
        bodySmall: TextStyle(fontSize: 12, color: textGrey),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textDark),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textGrey),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: textGrey),
      ),
      
      scaffoldBackgroundColor: warmWhite,
    );
  }
}
