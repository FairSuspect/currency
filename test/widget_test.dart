// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:currency/currency_widget.dart';
import 'package:currency/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency/main.dart';

void main() {
  testWidgets('Correct layout of currency card', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(CurrencyWidget(
      currency: Currency(
          nominal: 1,
          previous: 10,
          value: 11,
          charCode: "USD",
          name: "Доллар США",
          numCode: '444'),
    ));

    // Verify that our counter starts at 0.
    expect(find.text("USD"), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
