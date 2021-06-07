import 'package:flutter/services.dart';

class NumberInputFormatter extends TextInputFormatter {
  final int minValue;
  NumberInputFormatter({this.minValue = 0});
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    double? value = double.tryParse(newValue.text);
    if (value == null) return TextEditingValue(text: minValue.toString());

    if (newValue.text.isEmpty || value < minValue)
      return TextEditingValue(text: minValue.toString());
    else
      return newValue;
  }
}
