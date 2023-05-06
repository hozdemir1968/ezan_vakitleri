import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.teal,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
  );
}
