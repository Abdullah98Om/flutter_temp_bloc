import 'package:flutter/material.dart';
import 'package:flutter_temp_bloc/core/theme/app_color.dart';

class AppTextStyle {
  static TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 32 / 24,
    color: AppColor.secondaryColor,
  );
  static TextStyle h3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22 / 14,
    color: AppColor.darkBlueTextColor,
  );
}
