import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_text_style.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: MyAppColor.backgroundColor,
    primaryColor: MyAppColor.primaryColor,
    colorScheme: const ColorScheme.light(
      primary: MyAppColor.primaryColor,
      secondary: MyAppColor.secondaryColor,
    ),
    textTheme: TextTheme(
      displayLarge: MyTextStyles.bold24,
      displayMedium: MyTextStyles.bold20,
      titleMedium: MyTextStyles.medium16,
      bodyLarge: MyTextStyles.regular15,
      bodyMedium: MyTextStyles.regular14,
      bodySmall: MyTextStyles.regular12,
      labelSmall: MyTextStyles.regular10,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: MyAppColor.backgroundColor,
      foregroundColor: MyAppColor.darkTextColor,
      elevation: 0,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: MyAppColor.darkBackground,
    primaryColor: MyAppColor.primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: MyAppColor.primaryColor,
      secondary: MyAppColor.secondaryColor,
    ),
    textTheme: const TextTheme(
      displayLarge: MyTextStyles.bold24,
      displayMedium: MyTextStyles.bold20,
      titleMedium: MyTextStyles.medium16,
      bodyLarge: MyTextStyles.regular15,
      bodyMedium: MyTextStyles.regular14,
      bodySmall: MyTextStyles.regular12,
      labelSmall: MyTextStyles.regular10,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: MyAppColor.darkBackground,
      foregroundColor: MyAppColor.lightTextColor,
      elevation: 0,
    ),
  );
}
