import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double tablet = 600;
}

extension ContextExtension on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get safeArea => MediaQuery.viewPaddingOf(this);

  bool get isMobile => screenWidth < AppBreakpoints.tablet;

  bool get isTablet => screenWidth >= AppBreakpoints.tablet;

  T responsive<T>({required T mobile, T? tablet}) {
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  double responsiveHeight({required double mobile, double? tablet}) {
    return responsive(mobile: mobile, tablet: tablet);
  }

  double responsiveWidth({required double mobile, double? tablet}) {
    return responsive(mobile: mobile, tablet: tablet);
  }
}
