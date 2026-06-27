import 'package:intl/intl.dart';

import '../../core/my_logger.dart';

class DateTimeConverter {
  static String dateTimeToYYYYMMddHHmm(DateTime dateTime) {
    var formattedDate = DateFormat("yyyy/MM/dd HH:mm").format(dateTime);
    return formattedDate;
  }

  static String dateTimeToLocalDateTime(DateTime dateTime) {
    var formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
    return formattedDate;
  }

  static String dateTimeToHHmm(DateTime dateTime) {
    var formattedDate = DateFormat("HH:mm").format(dateTime);
    return formattedDate;
  }

  static DateTime? dateTimeFromLocalDateTime(String? dateTime) {
    if (dateTime == null) return null;
    try {
      return DateFormat("yyyy-MM-dd HH:mm:ss").parseStrict(dateTime);
    } catch (e) {
      MyLogger.e(e);
      return null;
    }
  }

  static DateTime? parse(String? datetimeString) {
    if (datetimeString == null) return null;
    try {
      DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'+09:00'");
      final dt = format.parse(datetimeString);
      return dt;
    } catch (e) {
      MyLogger.e(e);
      return null;
    }
  }
}
