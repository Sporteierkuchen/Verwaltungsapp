import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

class HelperUtil {

  static String formatDateTime(DateTime datetime) {
    return DateFormat('dd.MM.yyyy').format(datetime);
  }

  static int getDifferenceDates(String date) {
    DateTime now = DateTime.now();
    DateTime datum = DateTime.parse(date);

    DateTime nowFormated = DateTime(now.year, now.month, now.day);
    DateTime datumFormated = DateTime(datum.year, datum.month, datum.day);

    int difference =
        (datumFormated.difference(nowFormated).inHours / 24).round();
    // print("Difference: $difference Warnzeit: ${article.warnzeit}");

    return difference;
  }


}
