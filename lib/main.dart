import 'dart:convert';
import 'dart:io';

import 'package:currency/currency_widget.dart';
import 'package:currency/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Курс рубля',
      theme: ThemeData.dark(),
      home: CurrencyPage(title: 'Курс рубля'),
    );
  }
}

class CurrencyPage extends StatefulWidget {
  CurrencyPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  void _reload() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => CurrencyPage(title: widget.title)));
  }

  List<String> possibleCharCodes = [
    "USD",
    "EUR",
    "UAH",
    "INR",
    "CAD",
    "AUD",
    "KGS",
    "CNY",
    "MDL",
    "NOK",
    "PLN",
    "RON",
    "XDR",
    "SGD",
    "AZN",
    "GBP",
    "AMD",
    "BYN",
    "BGN",
    "BRL",
    "HUF",
    "HKD",
    "DKK",
    "KZT",
    "TJS",
    "TRY",
    "TMT",
    "UZS",
    "CZK",
    "SEK",
    "CHF",
    "ZAR",
    "KRW",
    "JPY"
  ];

  Future<List<Currency?>?> _getData() async {
    var uri = Uri.parse("https://cbr-xml-daily.ru/daily_json.js");
    var response = await http.get(uri);

    var _json = json.decode(response.body)[r'Valute'];
    List values = List.empty(growable: true);

    possibleCharCodes.forEach((e) {
      values.add(_json[e]);
    });
    return Currency.listFromJson(values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(onPressed: _reload, icon: Icon(Icons.refresh))],
      ),
      body: Center(
        child: _future(),
      ),
    );
  }

  Widget _future() => FutureBuilder<List<Currency?>?>(
      future: _getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return CurrencyWidget(
                  currency: snapshot.data![index]!,
                );
              });
        } else if (snapshot.hasError) if (snapshot.error.runtimeType ==
            SocketException) {
          var error = snapshot.error as SocketException;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Нет подключения к интернету",
                style: Theme.of(context).textTheme.headline5,
              ),
              Text("${error.message} \n ${error.address}:${error.port}"),
              ElevatedButton.icon(
                  onPressed: _reload,
                  icon: Icon(Icons.repeat),
                  label: Text("Попробовать еще раз"))
            ],
          );
        } else {
          return Text(snapshot.error.toString());
        }
        else
          return CircularProgressIndicator();
      });
}
