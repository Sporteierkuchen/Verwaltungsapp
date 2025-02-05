
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Klassen/Meldung.dart';
import '../page/EditPage.dart';
import '../page/MengenPage.dart';
import '../util/HelperUtil.dart';
import 'Bestätigung.dart';

class ArticleWidget extends StatefulWidget {

  final DocumentSnapshot article;

  const ArticleWidget(
      {Key? key, required this.article,

      })
      : super(key: key);

  @override
  _ArticleWidgetState createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {

  bool loadedData = true;

  @override
  void initState() {
    super.initState();

    // print("Init State Article-Widget");

  }

  @override
  void dispose() {
    super.dispose();
   // print("Disposed Article-Widget");
  }

  @override
  Widget build(BuildContext context) {

   // print("Build Article-Widget");

        return

          Slidable(
            endActionPane: ActionPane(
              extentRatio: 1,
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  autoClose: true,
                  borderRadius: BorderRadius.circular(10.0),
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

                            BestaetigungsDialog(title: "Artikel löschen", message: "Soll der Artikel \"${widget.article['name']}\" wirklich gelöscht werden?",
                                onConfirm: () async {

                                  print("Ja geklickt!");
                                  await deleteArticle(widget.article.id, widget.article['logopath']);

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
            startActionPane: ActionPane(
              extentRatio: 1,
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  autoClose: true,
                  borderRadius: BorderRadius.circular(10.0),
                  padding: const EdgeInsets.all(5),
                  onPressed: (value)  {
                    if (loadedData) {

                      print("Artikel bearbeiten!");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPage(articleId: widget.article.id),
                        ),
                      );

                    }
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.black,
                  icon: Icons.mode_edit_outlined,
                  label: 'Bearbeiten',
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {

                if(loadedData){

                  print("Ausgewählter Artikel: ${widget.article['name']}");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MengenPage(articleId: widget.article.id),
                    ),
                  );

                }

              },
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.all(5),
                  color: widget.article['istmenge'] <
                      widget.article['sollmenge']
                      ? Colors.yellow[300]
                      : Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Container(
                          padding: const EdgeInsets.all(
                              2), // Border width
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(
                                  35), // Image radius
                              child: widget.article['logopath'].isEmpty
                                  ? Image.asset(
                                  "lib/images/articles/empty.png",
                                  fit: BoxFit.cover)
                                  : Image.network(
                                widget.article['logopath'],
                                fit: BoxFit.cover,

                                gaplessPlayback: true,
                                // filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                vertical: 10),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.article['name'],
                                  style: const TextStyle(
                                    height: 0,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Soll: ${widget.article['sollmenge']}     Ist: ${widget.article['istmenge']}",
                                  style: const TextStyle(
                                    height: 0,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                widget.article['istmenge'] <
                                    widget.article['sollmenge']
                                    ? Padding(
                                  padding:
                                  const EdgeInsets
                                      .only(top: 8),
                                  child: Text(
                                    "Nachzukaufen: ${widget.article['sollmenge'] - widget.article['istmenge']}",
                                    style:
                                    const TextStyle(
                                      height: 0,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      color:
                                      Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),

                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Menge') // Name der Collection
                              .where('artikelId', isEqualTo: widget.article.id)
                              .orderBy("datum", descending: true)
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
                              // return const SizedBox.shrink();
                            }

                            if (snapshot.data == null) {
                              return const SizedBox.shrink();
                            }

                            List<QueryDocumentSnapshot<Object?>> mengen =
                                snapshot.data!.docs;

                            return
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                child:
                                Column(
                                    children: getColorWidget(mengen, widget.article['warnzeit'])
                                ),
                              );

                          },
                        ),

                      ],
                    ),
                  )),
            ),
          );

  }

  Future<void> deleteArticle(String articleId, String logopath) async {
    try {

      //1. Bild aus Firebase Storage löschen (Fehler ignorieren, falls nicht vorhanden)
      if (logopath.isNotEmpty) {
        try {
          final storageRef = FirebaseStorage.instance.refFromURL(logopath);
          await storageRef.delete();
        } catch (e) {
          print("Bild konnte nicht gelöscht werden (möglicherweise nicht vorhanden): $e");
        }
      }

      final articleRef = FirebaseFirestore.instance.collection("Article").doc(articleId);

      // Mengen-Dokumente abrufen
      final mengeQuery = await FirebaseFirestore.instance
          .collection("Menge")
          .where("artikelId", isEqualTo: articleId)
          .get();

      //2. Alles in einer Transaktion ausführen
      await FirebaseFirestore.instance.runTransaction((transaction) async {

        final articleSnap = await transaction.get(articleRef);

        // Mengen-Dokumente in der Transaktion löschen (falls vorhanden)
        for (var doc in mengeQuery.docs) {
          transaction.delete(doc.reference);
        }

        // Prüfen, ob Artikel existiert, bevor er gelöscht wird
        if (articleSnap.exists) {
          transaction.delete(articleRef);
        }

      });

      // Erfolgsmeldung
      if (mounted) {
        HelperUtil.getToast(
          meldung: Meldung(
            meldungsart: Meldungsart.SUCCESS,
            text: "Der Artikel wurde gelöscht!",
          ),
          context: context,
        );
      }

    } catch (e) {
      print("Fehler beim Löschen des Artikels: $e");

      if (mounted) {
        HelperUtil.getToast(
          meldung: Meldung(
            meldungsart: Meldungsart.ERROR,
            text: "Fehler beim Löschen des Artikels!",
          ),
          context: context,
        );
      }
    }
  }

  List<Widget> getColorWidget(List<QueryDocumentSnapshot<Object?>> mengen, int warnzeit) {

    bool ok= false;
    bool warning = false;
    bool abgelaufen = false;

    List<Widget> colorWidgets = [];

    try {

      if(mengen.isEmpty){
          colorWidgets.add(
              const Icon(
                  Icons.star,
                  color: Colors.black,
                  size: 40,
                )
          );
          return colorWidgets;
      }

      for (DocumentSnapshot menge in mengen) {

        if (ok && warning && abgelaufen) {
          return colorWidgets;
        }

        DateTime mengeDatum = (menge["datum"] as Timestamp).toDate();

        int differenceDates = HelperUtil.getDifferenceDates(
            mengeDatum.toString());

        if (differenceDates >= 0 && differenceDates > warnzeit &&
            warnzeit != -1) {
          if (!ok) {
            colorWidgets.add(
                const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 40,
                )
            );
            ok = true;
          }
        } else if (differenceDates >= 0 && differenceDates <= warnzeit &&
            warnzeit != -1) {
          if (!warning) {
            colorWidgets.add(
                const Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 40,
                )
            );
            warning = true;
          }
        } else if (differenceDates < 0) {
          if (!abgelaufen) {
            colorWidgets.add(
                const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 40,
                )
            );
            abgelaufen = true;
          }
        }

      }

    } catch (e) {
      print("Fehler beim Ermitteln der Color-Widgets: $e");
      HelperUtil.getToast(
        meldung: Meldung(
            meldungsart: Meldungsart.ERROR,
            text:
            "Fehler beim Ermitteln der Color-Widgets: ${e.toString()}"),
        context: context,
      );
    }

    return colorWidgets;
  }

}
