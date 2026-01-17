import 'package:flutter/material.dart';

class AppColor {
  static const Color backgroundColor = Color(0xffffffff);
  static const Color primaryColor = Color(0xFF376AED);
  ////////////////////////////////////////////////////////////////////////////////
  static const Color secondaryColor = Color(0xff0D253C);
  ///////////////////////////////////////////////////////////////////////////////
  static const Color darkBlueTextColor = Color(0xff2D4379);
  static const Color darkGrayColor = Color(0xff7B8BB2);
}

class AppShadow {
  static BoxShadow shadow1 = BoxShadow(
    color: AppColor.secondaryColor.withValues(alpha: 0.3),
    blurStyle: BlurStyle.normal,
    offset: Offset(0, 16),
    blurRadius: 40,
    spreadRadius: 0,
  );
}

class AppLinearGradient {
  static LinearGradient linearGradient1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff376AED), Color(0xff49B0E2), Color(0xff9CECFB)],
  );
}
