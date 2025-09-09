import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lighTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.purple,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarThemeData(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.purple,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarThemeData(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}
