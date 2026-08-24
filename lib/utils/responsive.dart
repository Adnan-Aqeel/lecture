import 'package:flutter/material.dart';

/// Shared Android phone/tablet layout values.
///
/// Decisions are based on logical width so the same rules work across Android
/// devices without depending on a particular model or pixel density.
class ResponsiveValues {
  const ResponsiveValues._({required this.width});

  factory ResponsiveValues.from(BuildContext context) =>
      ResponsiveValues._(width: MediaQuery.sizeOf(context).width);

  final double width;

  bool get isCompactPhone => width < 360;
  bool get isTablet => width >= 600;
  bool get isPhone => !isTablet;

  double get pagePadding {
    if (isCompactPhone) return 12;
    if (isTablet) return 24;
    return 16;
  }

  int get gridColumns {
    if (width < 360) return 1;
    if (width < 600) return 1;
    if (width < 900) return 2;
    return 3;
  }

  bool get useTwoColumnForm => isTablet;
}
