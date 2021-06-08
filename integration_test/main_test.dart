import 'dart:io';

import 'package:currency/currency_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:currency/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("App start", () {
    testWidgets("Online", (WidgetTester tester) async {
      // await tester.binding.
      double value = -1;
      app.main();
      await tester.pumpAndSettle();
      final usdFinder = find.byWidgetPredicate((widget) {
        if (widget is CurrencyWidget && widget.currency?.charCode == "USD") {
          print("Found  $widget");
          value = widget.currency!.value!;
        }
        return widget is CurrencyWidget && widget.currency?.charCode == "USD";
      });

      final inputFinder = find.byWidgetPredicate(
          (widget) => widget is TextFormField && widget.key == Key("USD"));

      await tester.enterText(inputFinder, "10");
      await tester.pumpAndSettle();
      expect(usdFinder, findsOneWidget);
      print(value);
      print((value * 10).toStringAsFixed(3));
      final valueFinder = find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.data!.contains((value * 10).toStringAsFixed(3)));
      expect(valueFinder, findsOneWidget);
      final refreshFinder = find.byIcon(Icons.refresh);
      print(value);

      await tester.tap(refreshFinder);
      await tester.pumpAndSettle();
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Text &&
              widget.data!.contains((value).toStringAsFixed(3))),
          findsOneWidget);
    });
  });
}
