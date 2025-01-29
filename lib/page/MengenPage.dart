import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:verwaltungsapp/util/HelperUtil.dart';
import 'package:verwaltungsapp/widget/MengeWidget.dart';
import '../Klassen/Meldung.dart';

class MengenPage extends StatefulWidget {
  final String articleId;
  const MengenPage({Key? key, required this.articleId}) : super(key: key);

  @override
  State<MengenPage> createState() => _MengenPageState();
}

class _MengenPageState extends State<MengenPage> {

  bool hasPopped = false;

  bool loadedData = true;

  late TextEditingController mengeTextController;
  late FocusNode _focusNode;

  DateTime? datum;

  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    print("Init State Mengen-Page");

    mengeTextController= TextEditingController();
    _focusNode = FocusNode();
    mengeTextController.text = "0";
  }

  @override
  dispose() {
   // print("Disposed Mengen-Page");

    mengeTextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // print("Build Mengen-Page");

    return PopScope(
      canPop: loadedData ? true : false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child:

            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Article')
                  .doc(widget.articleId)
                  .snapshots(),
              builder: (context, snapshot) {

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.red)),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }

                DocumentSnapshot<Object?>? article;

                // Prüfen, ob das Dokument existiert
                if (snapshot.data != null &&  !snapshot.data!.exists) {

                  print("Mengen-Page: Artikel wurde gelöscht!");

                  if (!hasPopped && mounted) {
                    hasPopped = true; // Verhindert mehrfaches `pop()`
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    });
                  }

                } else {
                  article = snapshot.data;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.all(2), // Border width
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          50), // Image radius
                                      child: article != null
                                          ? article["logopath"].isEmpty
                                              ? Image.asset(
                                                  "lib/images/articles/empty.png",
                                                  fit: BoxFit.cover)
                                              : Image.network(
                                                  article["logopath"],
                                                  fit: BoxFit.cover,

                                                  gaplessPlayback: true,
                                                  // filterQuality: FilterQuality.high,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    // Leeres Bild oder alternative UI-Komponente im Fehlerfall anzeigen
                                                    return Image.asset(
                                                      "lib/images/articles/empty.png",
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                )
                                          : Image.asset(
                                              "lib/images/articles/empty.png",
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: article != null
                                  ? Text(
                                      article["name"],
                                      softWrap: true,
                                      //maxLines: 1,
                                      style: const TextStyle(
                                        height: 0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 26,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Menge') // Name der Collection
                              .where('artikelId',
                                  isEqualTo:
                                      widget.articleId) // Filter nach artikelId
                              .orderBy("datum", descending: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Error: ${snapshot.error}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.red)),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            List<QueryDocumentSnapshot<Object?>> mengen =
                                snapshot.data!.docs;

                            return mengen.isEmpty
                                ? Container(
                                    alignment: Alignment.center,
                                    child: const Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          "Noch nichts hinzugefügt!",
                                          style: TextStyle(
                                            height: 0,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        )),
                                  )
                                : SlidableAutoCloseBehavior(
                                    closeWhenOpened: true,
                                    child: ListView.builder(
                                        //  shrinkWrap: true,
                                        // physics: const ScrollPhysics(),
                                        itemCount: mengen.length,
                                        itemBuilder: (context, index) {
                                          final menge = mengen[index];

                                          return MengeWidget(
                                              menge: menge,
                                              warnzeit: article!["warnzeit"] as int,
                                              articleId: widget.articleId);

                                        }),
                                  );
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      padding: const EdgeInsets.only(top: 15, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Anzahl",
                                style: TextStyle(
                                  height: 0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (loadedData) {
                                        try {
                                          int menge = int.parse(
                                              mengeTextController.text);

                                          if (menge < 0) {
                                            mengeTextController.text = "0";
                                          } else if (menge == 0) {
                                          } else {
                                            menge--;
                                            mengeTextController.text =
                                                menge.toString();
                                          }
                                        } catch (e) {
                                          mengeTextController.text = "0";
                                        }

                                        setState(() {});
                                      }
                                    },
                                    child: const Icon(
                                      Icons.arrow_left,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
                                      height: 40,
                                      child: TextField(
                                        controller: mengeTextController,
                                        focusNode: _focusNode,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        maxLength: 25,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.only(),
                                          filled: true,
                                          fillColor: Colors.white,
                                          counterText: "",
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(0.0)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(0.0)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (loadedData) {
                                        try {
                                          int menge = int.parse(
                                              mengeTextController.text);

                                          if (menge < 0) {
                                            mengeTextController.text = "0";
                                          } else {
                                            menge++;
                                            mengeTextController.text =
                                                menge.toString();
                                          }
                                        } catch (e) {
                                          mengeTextController.text = "0";
                                        }

                                        setState(() {});
                                      }
                                    },
                                    child: const Icon(
                                      Icons.arrow_right,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Mindesthaltbarkeitsdatum",
                                style: TextStyle(
                                  height: 0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (loadedData) {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        locale: const Locale("de", "DE"),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2050),
                                        initialDate: DateTime.now());

                                    if (pickedDate != null) {
                                      datum = pickedDate;
                                    }

                                    setState(() {});
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.blue,
                                  side: const BorderSide(
                                      color: Colors.black, width: 1),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  // Text Color (Foreground color)
                                ),
                                child: datum != null
                                    ? Text(
                                        DateFormat('dd.MM.yyyy').format(datum!),
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      )
                                    : const Text(
                                        'Datum auswählen',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (loadedData) {
                                print("Zurück!");

                                mengeTextController.text = "0";
                                datum = null;

                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red[300],
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // Text Color (Foreground color)
                            ),
                            child: const Icon(
                              Icons.arrow_back_outlined,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),

                          // SizedBox(width: MediaQuery.of(context).size.width* 0.05),

                          ElevatedButton(
                            onPressed: () async {
                              if (loadedData) {
                                setState(() {
                                  loadedData = false;
                                });

                                if (checkUserInputMenge()) {
                                  await addOrUpdateMenge(
                                      datum!,
                                      int.parse(
                                          mengeTextController.text.trim()));
                                } else {
                                  print("Fehler Eingabe!");
                                  HelperUtil.getToast(
                                      meldung: Meldung(
                                          meldungsart: Meldungsart.WARNING,
                                          text: errorMessage),
                                      context: context);
                                }

                                setState(() {
                                  loadedData = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green[300],
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // Text Color (Foreground color)
                            ),
                            child: const Text(
                              'Hinzufügen',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool checkUserInputMenge() {
    errorMessage = "";

    if (datum == null) {
      errorMessage += "Gebe ein Datum ein!\n";
    }

    if (mengeTextController.text.trim().isEmpty) {
      errorMessage += "Gebe eine Menge ein!\n";
    } else {
      try {
        int menge = int.parse(mengeTextController.text.trim());
        if (menge < 0) {
          errorMessage += "Die Menge darf nicht negativ sein!\n";
        }
        if (menge == 0) {
          errorMessage += "Die Menge darf nicht 0 sein!\n";
        }
      } catch (e) {
        errorMessage += "Die Menge muss eine Zahl sein!\n";
      }
    }

    if (errorMessage.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  /// Funktion zum Hinzufügen oder Aktualisieren einer Menge
  Future<void> addOrUpdateMenge(DateTime datum, int anzahl) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection("Menge")
          .where('artikelId', isEqualTo: widget.articleId)
          .where("datum",
              isEqualTo: Timestamp.fromDate(
                  DateTime(datum.year, datum.month, datum.day)))
          .get();

      if (query.docs.isNotEmpty) {
        // Dokument mit diesem Datum existiert -> Anzahl aktualisieren
        final doc = query.docs.first;
        final currentAnzahl = doc["menge"] as int;

        await FirebaseFirestore.instance
            .collection("Menge")
            .doc(doc.id)
            .update({
          "menge": currentAnzahl + anzahl,
        });

        print("Vorhandene Menge aktualisiert.");
        if (mounted) {
          HelperUtil.getToast(
            meldung: Meldung(
                meldungsart: Meldungsart.SUCCESS,
                text:
                "Menge erfolgreich aktualisiert und Anzahl $anzahl hinzugefügt."),
            context: context,
          );
        }

      } else {
        // Neues Dokument hinzufügen
        await FirebaseFirestore.instance.collection("Menge").add({
          "artikelId": widget.articleId,
          "datum":
              Timestamp.fromDate(DateTime(datum.year, datum.month, datum.day)),
          "menge": anzahl,
        });

        print("Neue Menge hinzugefügt.");
        if (mounted) {
          HelperUtil.getToast(
            meldung: Meldung(
                meldungsart: Meldungsart.SUCCESS,
                text: "Neue Menge hinzugefügt mit Anzahl $anzahl."),
            context: context,
          );
        }

      }

      final article = await FirebaseFirestore.instance
          .collection("Article")
          .doc(widget.articleId)
          .get();

      int artikelAnzahl = article["istmenge"] as int;

      await FirebaseFirestore.instance
          .collection('Article')
          .doc(widget.articleId)
          .update({
        'istmenge': artikelAnzahl + anzahl,
      });
    } catch (e) {
      print("Fehler beim Hinzufügen/Aktualisieren der Menge: $e");
      if (mounted) {
        HelperUtil.getToast(
          meldung: Meldung(
              meldungsart: Meldungsart.ERROR,
              text:
              "Fehler beim Hinzufügen/Aktualisieren der Menge: ${e.toString()}"),
          context: context,
        );
      }

    }
  }

}
