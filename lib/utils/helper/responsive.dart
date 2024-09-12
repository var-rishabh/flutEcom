import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(context) {
    return MediaQuery.of(context).size.width < 850;
  }

  static bool isTablet(context) {
    return MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 850;
  }

  static bool isDesktop(context) {
    return MediaQuery.of(context).size.width >= 1100;
  }
}
