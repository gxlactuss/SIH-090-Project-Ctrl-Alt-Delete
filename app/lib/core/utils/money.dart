import 'package:intl/intl.dart';

abstract final class Money {
  static String rupees(int paise, String localeName) {
    final format = NumberFormat.currency(
      locale: localeName,
      symbol: '₹',
      decimalDigits: 0,
    );
    return format.format(paise / 100);
  }
}
