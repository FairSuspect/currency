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
          value = widget.currency!.value!;
        }
        return widget is CurrencyWidget && widget.currency?.charCode == "USD";
      });

      final inputFinder = find.byWidgetPredicate(
          (widget) => widget is TextFormField && widget.key == Key("USD"));
      // Вводится 10
      await tester.enterText(inputFinder, "10");
      // Ожидание обновления состояния
      await tester.pumpAndSettle();
      // Необходимо запустить поиск для добавления значения, так как оно заранее неизвестно
      expect(usdFinder, findsOneWidget);
      final valueFinder = find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.data!.contains((value * 10).toStringAsFixed(3)));

      // Поиск полученного значения, умноженного на 10
      expect(valueFinder, findsOneWidget);

      final refreshFinder = find.byIcon(Icons.refresh);
      // Нажатие на кнопку обновления
      await tester.tap(refreshFinder);
      await tester.pumpAndSettle();
      // Обновление данных, так как они могли измениться (сервер обновляет каждые 10 минут)
      expect(usdFinder, findsOneWidget);
      // При обновлении страницы значение в поле для ввода должно сброситься обратно к номиналу, получаемому с сервера (1 для USD)
      expect(
          find.byWidgetPredicate((widget) =>
              widget is Text &&
              widget.data!.contains((value).toStringAsFixed(3))),
          findsOneWidget);
    });
  });
}
