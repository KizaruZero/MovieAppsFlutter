import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF1E1E1E),
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF2C2C2C),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
  );
}
