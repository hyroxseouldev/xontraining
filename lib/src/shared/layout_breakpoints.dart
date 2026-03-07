import 'package:flutter/widgets.dart';

abstract final class LayoutBreakpoints {
  static const double tabletShortestSide = 600;

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= tabletShortestSide;
  }
}
