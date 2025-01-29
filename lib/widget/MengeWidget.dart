
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../Klassen/Meldung.dart';
import '../page/EntnehmenPage.dart';
import '../util/HelperUtil.dart';
import 'Bestätigung.dart';

class MengeWidget extends StatefulWidget {

  final DocumentSnapshot menge;
  final int warnzeit;
  final String articleId;

  const MengeWidget(
      {Key? key, required this.menge, required this.warnzeit, required this.articleId,

      })
      : super(key: key);

  @override
  _MengeWidgetState createState() => _MengeWidgetState();
}

class _MengeWidgetState extends State<MengeWidget> {

  bool loadedData = true;

  @override
  void initState() {
    super.initState();

    // print("Init State Menge-Widget");

  }

  @override
  void dispose() {
    super.dispose();
   // print("Disposed Menge-Widget");
  }

  @override
  Widget build(BuildContext context) {

   // print("Build Menge-Widget");

    return
      Slidable(
      endActionPane: ActionPane(
        extentRatio: 1,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            borderRadius:
            BorderRadius.circular(10.0),
            padding: const EdgeInsets.all(5),
            onPressed: (value) async {
              if (loadedData) {

                setState(() {
                  loadedData = false;
                });

                await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                          dialogBackgroundColor:
                          Colors.black),
                      child:

                      BestaetigungsDialog(title: "Menge löschen", message: "Soll die Menge mit der Anzahl ${widget.menge["menge"]} und dem Mindesthaltbarkeitsdatum \"${HelperUtil.formatDateTime((widget.menge["datum"] as Timestamp).toDate())}\" wirklich gelöscht werden?",
                          onConfirm: () async {

                            print("Ja geklickt!");
                            await deleteMenge(widget.menge);

                          },
                          onCancel: (){
                            print("Nein geklickt!");
                          }
                      ),

                    );
                  },
                );

                setState(() {
                  loadedData = true;
                });

              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
            icon: Icons.delete,
            label: 'Löschen',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (loadedData) {

            print("Ausgewählte Menge: Anzahl: ${widget.menge["menge"]} Datum: ${HelperUtil.formatDateTime((widget.menge["datum"] as Timestamp).toDate())}");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EntnehmenPage(articleId: widget.articleId, mengeId: widget.menge.id),
              ),
            );

          }
        },
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.all(5),
            color: Colors.white,
            elevation: 3,
            child: Padding(
              padding:
              const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(children: [
                    const Text(
                      "Anzahl",
                      style: TextStyle(
                        height: 0,
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Card(
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            10.0),
                      ),
                      margin: const EdgeInsets
                          .symmetric(
                          vertical: 3),
                      color: Colors.grey,
                      elevation: 3,
                      child: Padding(
                        padding:
                        const EdgeInsets
                            .symmetric(
                            horizontal:
                            15,
                            vertical: 10),
                        child: Text(
                          widget.menge["menge"]
                              .toString(),
                          style:
                          const TextStyle(
                            height: 0,
                            fontWeight:
                            FontWeight
                                .bold,
                            color:
                            Colors.black,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          "Mindesthaltbarkeitsdatum",
                          style: TextStyle(
                            height: 0,
                            fontWeight:
                            FontWeight
                                .bold,
                            color:
                            Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          mainAxisSize:
                          MainAxisSize
                              .max,
                          children: [

                            Expanded(
                              child:
                              Container(
                                margin: const EdgeInsets
                                    .symmetric(
                                    vertical:
                                    3),
                                decoration: const BoxDecoration(
                                    color: Colors
                                        .transparent,
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(10))),
                                child:
                                Padding(
                                  padding: const EdgeInsets
                                      .symmetric(
                                      horizontal:
                                      15,
                                      vertical:
                                      10),
                                  child: Text(
                                    HelperUtil.formatDateTime((widget.menge["datum"]
                                    as Timestamp)
                                        .toDate().toLocal()),
                                    style:
                                    const TextStyle(
                                      height:
                                      0,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors
                                          .black,
                                      fontSize:
                                      22,
                                    ),
                                    textAlign:
                                    TextAlign
                                        .center,
                                  ),
                                ),
                              ),
                            ),

                            getColorWidget(widget.menge),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );

  }

  Widget getColorWidget(DocumentSnapshot menge) {

    try {

      DateTime mengeDatum = (menge["datum"] as Timestamp).toDate();

      int differenceDates = HelperUtil.getDifferenceDates(mengeDatum.toString());

      if (differenceDates >= 0 && differenceDates > widget.warnzeit && widget.warnzeit !=-1) {
        return const Icon(
          Icons.check,
          color: Colors.green,
          size: 40,
        );
      } else if (differenceDates >= 0 && differenceDates <= widget.warnzeit && widget.warnzeit !=-1) {
        return const Icon(
          Icons.warning,
          color: Colors.orange,
          size: 40,
        );
      } else if (differenceDates < 0) {
        return const Icon(
          Icons.error,
          color: Colors.red,
          size: 40,
        );
      }

    } catch (e) {
      print("Fehler beim Ermitteln des Zeitunterschiedes der Menge: $e");
      HelperUtil.getToast(
        meldung: Meldung(
            meldungsart: Meldungsart.ERROR,
            text:
            "Fehler beim Ermitteln des Zeitunterschiedes der Menge: ${e.toString()}"),
        context: context,
      );
    }
    return Container();
  }

  Future<void> deleteMenge(DocumentSnapshot menge) async {

    try {

      await FirebaseFirestore.instance.collection("Menge").doc(menge.id).delete();

      final article = await FirebaseFirestore.instance
          .collection("Article")
          .doc(widget.articleId)
          .get();

      int artikelAnzahl = article["istmenge"] as int;

      await FirebaseFirestore.instance
          .collection('Article')
          .doc(widget.articleId)
          .update({
        'istmenge': artikelAnzahl - menge["menge"] as int,
      });

      print("Menge erfolgreich gelöscht!");
      if (mounted) {
        HelperUtil.getToast(
          meldung: Meldung(
              meldungsart: Meldungsart.SUCCESS,
              text:
              "Menge erfolgreich gelöscht!"),
          context: context,
        );
      }

    } catch (e) {
      print("Fehler beim Löschen der Menge: $e");

      if (mounted) {
        HelperUtil.getToast(
          meldung: Meldung(
              meldungsart: Meldungsart.ERROR,
              text:
              "Fehler beim Löschen der Menge: ${e.toString()}"),
          context: context,
        );
      }

    }
  }

}
