import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      centerTitle: true,
    ),
  );

  static ThemeData darkTheme = ThemeData.dark();
}
