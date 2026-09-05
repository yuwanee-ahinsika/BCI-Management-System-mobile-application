import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bci_management_system/main.dart';

void main() {
  testWidgets('App launches with BCIManagementApp root',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BCIManagementApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('BCI Campus'), findsOneWidget);
  });
}
