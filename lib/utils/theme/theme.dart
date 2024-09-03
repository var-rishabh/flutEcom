import 'package:flutter/material.dart';

// text theme
import 'package:flut_mart/utils/theme/text_theme.dart';

class KThemeData {
  // Primary Colors
  static const Color _primaryColor = Color(0xFFF21D08);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: Colors.white,
    textTheme: KTextTheme.suseTextTheme,
    buttonTheme: const ButtonThemeData(
      buttonColor: _primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
    ),
    iconTheme: const IconThemeData(color: Colors.black54),
    dividerColor: Colors.grey.shade300,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: _primaryColor,
      brightness: Brightness.light,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: Colors.grey.shade900,
    textTheme: KTextTheme.suseTextTheme,
    buttonTheme: const ButtonThemeData(
      buttonColor: _primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
    ),
    iconTheme: const IconThemeData(color: Colors.white54),
    dividerColor: Colors.grey.shade700,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: _primaryColor,
      brightness: Brightness.dark,
    ),
  );
}
