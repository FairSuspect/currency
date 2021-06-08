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
  testWidgets('Присутствуют все элементы', (WidgetTester tester) async {
    // Загрузка одного CurrencyWidget
    await tester.pumpWidget(MaterialApp(
      home: CurrencyPage(
        title: "Курс рубля",
        child: CurrencyWidget(
          currency: Currency(
              nominal: 1,
              previous: 10,
              value: 11,
              charCode: "USD",
              name: "Доллар США",
              numCode: '444'),
        ),
      ),
    ));
    // Присутствует текстовое поле
    expect(find.byWidgetPredicate((widget) => widget is TextFormField),
        findsOneWidget);
    // Присутствует текст относительного изменения
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data!.contains("%")),
        findsOneWidget);
    // Присутствует текст значения
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data!.contains("₽")),
        findsOneWidget);
    // Присутствует charcode валюты
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == "USD"),
        findsOneWidget);
  });
  testWidgets('Рост отображается правильно', (WidgetTester tester) async {
    // Загрузка одного CurrencyWidget с положительным изменением

    await tester.pumpWidget(MaterialApp(
      home: CurrencyPage(
        title: "Курс рубля",
        child: CurrencyWidget(
          currency: Currency(
              nominal: 1,
              previous: 10,
              value: 11,
              charCode: "USD",
              name: "Доллар США",
              numCode: '444'),
        ),
      ),
    ));

    // Отображается charcode валюты
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == "USD"),
        findsOneWidget);
    // Отображается правильное изменение
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data! == "10.00 %"),
        findsOneWidget);
// Отображается правильная стрелка (зеленная вверх)
    expect(
        find.byWidgetPredicate((widget) =>
            widget is Icon &&
            widget.icon == Icons.arrow_upward &&
            widget.color == Colors.greenAccent),
        findsOneWidget);
  });
  testWidgets('Падение отображается правильно', (WidgetTester tester) async {
    // Загрузка одного CurrencyWidget с отрицательным изменением

    await tester.pumpWidget(MaterialApp(
      home: CurrencyPage(
        title: "Курс рубля",
        child: CurrencyWidget(
          currency: Currency(
              nominal: 1,
              previous: 20,
              value: 10,
              charCode: "USD",
              name: "Доллар США",
              numCode: '444'),
        ),
      ),
    ));

    // Отображается charcode валюты
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == "USD"),
        findsOneWidget);
    // Отображается правильное изменение
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data! == "-50.00 %"),
        findsOneWidget);
// Отображается правильная стрелка (зеленная вверх)
    expect(
        find.byWidgetPredicate((widget) =>
            widget is Icon &&
            widget.icon == Icons.arrow_downward &&
            widget.color == Colors.redAccent),
        findsOneWidget);
  });
  testWidgets('Значение соотствует введённому количеству',
      (WidgetTester tester) async {
    // Загрузка одного CurrencyWidget с отрицательным изменением

    await tester.pumpWidget(MaterialApp(
      home: CurrencyPage(
        title: "Курс рубля",
        child: CurrencyWidget(
          currency: Currency(
              nominal: 1,
              previous: 20,
              value: 10,
              charCode: "USD",
              name: "Доллар США",
              numCode: '444'),
        ),
      ),
    ));
    await tester.enterText(
        find.byWidgetPredicate((widget) => widget is TextFormField), "150");
    await tester.pump();
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == "1500.000 ₽"),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data == "10.000 ₽"),
        findsNothing);
  });
}
