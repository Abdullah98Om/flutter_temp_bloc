import 'package:flutter/material.dart';
import 'package:flutter_temp_bloc/core/theme/app_color.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      surface: AppColor.darkGrayColor,
      primary: AppColor.primaryColor,
      secondary: AppColor.secondaryColor,
    ),
    scaffoldBackgroundColor: AppColor.backgroundColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      foregroundColor: AppColor.darkBlueTextColor,
      centerTitle: true,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.light(
      surface: Color.fromARGB(255, 158, 172, 208),
      primary: AppColor.primaryColor,
      secondary: AppColor.secondaryColor,
    ),
    scaffoldBackgroundColor: AppColor.backgroundColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      foregroundColor: AppColor.darkBlueTextColor,
      centerTitle: true,
    ),
  );
}
