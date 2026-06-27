import 'package:intl/intl.dart';

class IntFormatter {
  static String toThreeDigits(int number) {
    final formatter = NumberFormat("#,###");
    String result = formatter.format(number);

    return result;
  }
}

// TODO 元の型をextensionするのはあり?
extension Int on int {
  int get length => this.toString().length;
}
