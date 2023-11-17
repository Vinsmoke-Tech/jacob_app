import 'package:intl/intl.dart';

class CurrencyFormat {
  CurrencyFormat(int parse);

  static String convertToIdr(dynamic number, int decimalDigit, {required initialValue}) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  static String convertToIdrwithoutSymbol(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}


