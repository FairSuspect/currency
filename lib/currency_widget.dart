import 'package:currency/models/currency.dart';
import 'package:currency/number_formatter.dart';
import 'package:flutter/material.dart';

class CurrencyWidget extends StatefulWidget {
  final Currency? currency;
  const CurrencyWidget({Key? key, this.currency}) : super(key: key);

  @override
  _CurrencyWidgetState createState() => _CurrencyWidgetState();
}

class _CurrencyWidgetState extends State<CurrencyWidget> {
  double customValue = 1;
  @override
  void initState() {
    super.initState();
    customValue = widget.currency!.nominal!.toDouble();
  }

  Widget _subtitle() => Container(
        // maxWidth: 150,
        // maxHeight: 25,
        height: 25,
        width: 150,
        child: Row(
          children: [
            Text("За "),
            LimitedBox(
              maxWidth: 100,
              maxHeight: 25,
              child: TextFormField(
                key: Key(widget.currency?.charCode ?? "..."),
                decoration: InputDecoration(
                    border: OutlineInputBorder(gapPadding: 1), counterText: ''),
                initialValue: customValue.toStringAsFixed(0),
                inputFormatters: [NumberInputFormatter()],
                keyboardType: TextInputType.number,
                maxLength: 8,
                onChanged: (value) {
                  setState(() {
                    customValue = double.tryParse(value) ?? 1;
                  });
                },
              ),
            ),
            Text(" шт.")
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    double value = widget.currency?.value ?? -1;
    double previous = widget.currency?.previous ?? -1;
    double change = ((value - previous) / (previous)) * 100;

    return LimitedBox(
      maxHeight: 150,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: ListTile(
            title: Text(
                "${((widget.currency?.value ?? 0) * customValue / (widget.currency?.nominal ?? 1)).toStringAsFixed(3)} ₽"),
            subtitle: _subtitle(),
            trailing: Text(widget.currency?.charCode ?? "..."),
            leading: Container(
              width: MediaQuery.of(context).size.width == 800 ? 140 : 100,
              child: Center(
                child: Row(
                  children: [
                    Text(
                      "${change.toStringAsFixed(2)} %",
                      style: TextStyle(
                          color: change > 0
                              ? Colors.greenAccent
                              : Colors.redAccent),
                    ),
                    change > 0
                        ? Icon(
                            Icons.arrow_upward,
                            color: Colors.greenAccent,
                          )
                        : Icon(
                            Icons.arrow_downward,
                            color: Colors.redAccent,
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
