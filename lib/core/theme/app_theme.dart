import 'package:flutter/material.dart';
import 'app_color.dart';
import 'app_text_style.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.backgroundColor,
    primaryColor: AppColor.primaryColor,
    colorScheme: const ColorScheme.light(
      primary: AppColor.primaryColor,
      secondary: AppColor.secondaryColor,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      bodyLarge: AppTextStyles.bodyText,
      labelLarge: AppTextStyles.buttonText,
      bodySmall: AppTextStyles.caption,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.backgroundColor,
      foregroundColor: AppColor.darkTextColor,
      elevation: 0,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.darkBackground,
    primaryColor: AppColor.primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: AppColor.primaryColor,
      secondary: AppColor.secondaryColor,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      bodyLarge: AppTextStyles.bodyText,
      labelLarge: AppTextStyles.buttonText,
      bodySmall: AppTextStyles.caption,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.darkBackground,
      foregroundColor: AppColor.lightTextColor,
      elevation: 0,
    ),
  );
}
