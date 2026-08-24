import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lecture/utils/responsive.dart';

void main() {
  testWidgets('uses phone and tablet breakpoints from available width',
      (tester) async {
    late ResponsiveValues values;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            values = ResponsiveValues.from(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(values.isTablet, isFalse);
    expect(values.isCompactPhone, isFalse);
    expect(values.pagePadding, 16);
  });
}
