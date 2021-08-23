import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberFormatter {
  static String format(double price,
      {symbol = 'VND',
        String locale = 'vi',
        bool spaceAfterSymbol = false,
        bool autoRemoveDecimalDigits = true,
        int decimalDigits = 0}) {
    if (price == null) {
      return '';
    }
    String _symbol;
    if (symbol == false) {
      _symbol = '';
    } else if (symbol == true || symbol == null) {
      _symbol = 'VND';
    } else {
      _symbol = symbol;
    }
    if (spaceAfterSymbol && _symbol != null) {
      _symbol += " ";
    }
    //
    if (autoRemoveDecimalDigits && price % 1 == 0) {
      decimalDigits = 0;
    }

    return NumberFormat.currency(
      symbol: _symbol,
      locale: locale,
      decimalDigits: decimalDigits,
    ).format(price);
  }

  static num parse(String numberString) {
    return NumberFormat().parse(numberString);
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  String symbol;
  bool spaceAfterSymbol;
  int decimalDigits;

  CurrencyInputFormatter(
      {this.symbol, this.spaceAfterSymbol, this.decimalDigits});

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    double value;

    try {
      value = NumberFormatter.parse(newValue.text);
    } catch (e) {
      value = 0;
    }
    var amount = NumberFormatter.format(value,
        symbol: symbol ?? '',
        spaceAfterSymbol: spaceAfterSymbol ?? false,
        decimalDigits: decimalDigits ?? 0);
    var offset = value > 0 ? amount.length : 1;
    if (value == 0) {
      amount = amount.replaceAll('0', ' ');
    }

    return newValue.copyWith(
        text: amount, selection: new TextSelection.collapsed(offset: offset));
  }
}
