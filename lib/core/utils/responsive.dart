import 'package:flutter/material.dart';

/// Simple breakpoint helper for adapting layouts to screen size.
/// Not a full responsive framework — just enough to satisfy the
/// "responsive UI for different screen sizes" requirement sensibly.
class Responsive {
  Responsive._();

  static int productGridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 900) return 4; // tablet landscape / desktop
    if (width >= 600) return 3; // tablet portrait
    return 2; // phone
  }

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600;

  static double horizontalPadding(BuildContext context) =>
      isTablet(context) ? 32 : 16;
}