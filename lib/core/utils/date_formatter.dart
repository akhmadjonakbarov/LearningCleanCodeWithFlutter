import 'package:intl/intl.dart';

class DateFormatter {
  static String dateDashTimeFormat({
    required String date,
    bool timezone = false,
  }) {
    String formattedDate = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(timezone ? timeZoneParse(date: date) : DateTime.parse(date));
    return formattedDate;
  }

  static String dateDotTimeFormat({
    required String date,
    bool timezone = false,
  }) {
    String formattedDate = DateFormat(
      'dd.MM.yyyy HH:mm:ss',
    ).format(timezone ? timeZoneParse(date: date) : DateTime.parse(date));
    return formattedDate;
  }

  static String hoursDotTimeFormat({String? date}) {
    return DateFormat(
      "HH:mm:ss",
    ).format(date != null ? DateTime.parse(date) : DateTime.now());
  }

  static String dayWithMonth({String? date}) {
    return DateFormat(
      "d-MM",
    ).format(date != null ? DateTime.parse(date) : DateTime.now());
  }

  static String dateDashFormat({required String date, bool timezone = false}) {
    String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(timezone ? timeZoneParse(date: date) : DateTime.parse(date));
    return formattedDate;
  }

  static String dateDotFormat({required String date, bool timezone = false}) {
    String formattedDate = DateFormat(
      'dd.MM.yyyy',
    ).format(timezone ? timeZoneParse(date: date) : DateTime.parse(date));
    return formattedDate;
  }

  static DateTime timeZoneParse({required String date}) {
    var dateValue = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(date).toLocal();
    return dateValue;
  }
}
