import 'package:flutter/material.dart';

import 'package:flut_mart/utils/constants/colors.constant.dart';
import 'package:flut_mart/utils/theme/text.theme.dart';

class KThemeData {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: KColors.primaryColor,
    scaffoldBackgroundColor: KColors.bgLight,
    textTheme: KTextTheme.suseTextTheme,
    buttonTheme: const ButtonThemeData(
      buttonColor: KColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: KColors.primaryColor,
    ),
    iconTheme: const IconThemeData(color: KColors.lightBlackColor),
    dividerColor: KColors.greyShade700,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: KColors.secondaryColor,
      brightness: Brightness.light,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: KColors.primaryColor,
    scaffoldBackgroundColor: KColors.bgDark,
    textTheme: KTextTheme.suseTextTheme,
    buttonTheme: const ButtonThemeData(
      buttonColor: KColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: KColors.primaryColor,
    ),
    iconTheme: IconThemeData(color: KColors.greyShade300),
    dividerColor: KColors.greyShade300,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: KColors.whiteColor,
      brightness: Brightness.dark,
    ),
  );
}
