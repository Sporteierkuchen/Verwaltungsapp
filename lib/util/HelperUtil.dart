import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../Klassen/Meldung.dart';
import '../widget/Toast.dart';

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

  static void getToast(
      {
        required Meldung meldung,
        required BuildContext context
      })
  {
    if (meldung.meldungsart == Meldungsart.SUCCESS) {
      showSuccess(context, meldung.text);
    }
    else if (meldung.meldungsart == Meldungsart.INFO) {
      showInfo(context, meldung.text);
    }
    else if (meldung.meldungsart == Meldungsart.WARNING) {
      showWarning(context, meldung.text);
    }
    else if (meldung.meldungsart == Meldungsart.ERROR) {
      showError(context, meldung.text);
    }

  }


}
