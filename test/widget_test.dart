import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_greenpoint/main.dart';

void main() {
  testWidgets('GreenPoint app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GreenPointApp());

    expect(find.text('GreenPoint'), findsOneWidget);
    expect(find.text('สะสมแต้มเพื่อโลกใส 🌍'), findsOneWidget);
  });
}
