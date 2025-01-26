

class Meldung {
  Meldungsart meldungsart;
  String text;
  // SignUp User

Meldung({

  required this.meldungsart,
  required this.text,
});

}
enum Meldungsart {INFO, SUCCESS, WARNING, ERROR}

