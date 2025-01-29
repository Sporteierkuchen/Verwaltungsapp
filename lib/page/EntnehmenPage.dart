import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:verwaltungsapp/dto/ArticleDTO.dart';
import '../Klassen/Meldung.dart';
import '../dto/MengeDTO.dart';
import '../util/HelperUtil.dart';
import '../util/LiveApiRequest.dart';

class EntnehmenPage extends StatefulWidget {

  final String articleId;
  final String mengeId;
  const EntnehmenPage({Key? key, required this.articleId, required this.mengeId}) : super(key: key);

  @override
  State<EntnehmenPage> createState() => _EntnehmenPageState();
}

class _EntnehmenPageState extends State<EntnehmenPage> {

  bool hasPopped = false;

  bool loadedData = true;

  final entnehmenTextController = TextEditingController();

  String errorMessage = "";

  @override
  void initState() {
    super.initState();

    print("Init State Entnehmen-Page");

    entnehmenTextController.text = "0";

  }

  @override
  dispose() {
   // print("Disposed Entnehmen-Page");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // print("Build Entnehmen-Page");

    return

      PopScope(
        canPop: loadedData ? true : false ,
        child:
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child:

            Container(
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
                  if (!snapshot.hasData || !snapshot.data!.exists) {

                    print("Artikel wurde gelöscht!");

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

                  return
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                              padding: const EdgeInsets.all(2), // Border width
                              decoration: const BoxDecoration(
                                  color: Colors.black, shape: BoxShape.circle),
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(100), // Image radius
                                  child:
                                  article != null
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

                            Padding(
                              padding: const EdgeInsets.only( top: 10),
                              child:

                              article != null
                                  ? Text(
                                article["name"],
                                softWrap: true,
                                //maxLines: 1,
                                style: const TextStyle(
                                  height: 0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 30,
                                ),
                              )
                                  : const SizedBox.shrink(),

                            ),

                          ],
                        ),
                      ),


                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color:  Colors.transparent,
                          ),
                          padding: const EdgeInsets.only(bottom: 20),
                          child:

                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Menge') // Name der Collection
                                .doc(widget.mengeId)
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
                               // return const SizedBox.shrink();
                              }

                              DocumentSnapshot<Object?>? menge;

                              // Prüfen, ob das Dokument existiert
                              if (snapshot.data != null &&   !snapshot.data!.exists) {

                                print("Entnehmen-Page: Menge von Artikel wurde gelöscht!");

                                if (!hasPopped && mounted) {
                                  hasPopped = true; // Verhindert mehrfaches `pop()`
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  });
                                }

                              } else {
                                menge = snapshot.data;
                              }

                              return

                                Column(
                                  children: [

                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        margin: const EdgeInsets.all(5),
                                        color: Colors.white,
                                        elevation: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                          child: Row(
                                            children: [

                                              Column(children: [

                                                const Text(
                                                  "Anzahl",
                                                  style: TextStyle(
                                                    height: 0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                    fontSize: 18,
                                                  ),
                                                ),

                                                const SizedBox(height: 10,),

                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  margin: const EdgeInsets.symmetric(vertical: 3),
                                                  color: Colors.grey,
                                                  elevation: 3,
                                                  child:
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                    child:
                                                    menge != null ?
                                                    Text(menge["menge"].toString(),
                                                      style: const TextStyle(
                                                        height: 0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 25,
                                                      ),
                                                    )
                                                    :const SizedBox.shrink(),
                                                  ),
                                                ),

                                              ],),

                                              const SizedBox(
                                                width: 10,
                                              ),

                                              Expanded(
                                                child: Column(children: [

                                                  const Text(
                                                    "Mindesthaltbarkeitsdatum",
                                                    style: TextStyle(
                                                      height: 0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontSize: 18,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 10,),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [

                                                      Container(
                                                        margin: const EdgeInsets.symmetric(vertical: 3),
                                                        decoration: const BoxDecoration(
                                                            color:  Colors.transparent,
                                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                                        ),

                                                        child:
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                          child: menge != null ?
                                                          Text(
                                                            HelperUtil.formatDateTime((menge["datum"] as Timestamp).toDate().toLocal()),
                                                            style: const TextStyle(
                                                              height: 0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                              fontSize: 25,
                                                            ),
                                                          )
                                                          : const SizedBox.shrink(),
                                                        ),
                                                      ),

                                                      menge != null ?
                                                      getColorWidget(menge, article!["warnzeit"] as int)
                                                      : const SizedBox.shrink(),

                                                    ],),

                                                ],),
                                              ),

                                            ],
                                          ),
                                        )
                                    ),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20 ,vertical: 20),

                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            const Text(
                                              "Anzahl",
                                              style: TextStyle(
                                                height: 0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 22,
                                              ),
                                            ),

                                            const SizedBox(height: 5,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                GestureDetector(
                                                  onTap: () {

                                                    if(loadedData){

                                                      try {

                                                        int anzahl = int.parse(entnehmenTextController.text);

                                                        if(anzahl<0 || anzahl > menge!["menge"]){
                                                          entnehmenTextController.text = "0";
                                                        }
                                                        else if(anzahl == 0){
                                                        }
                                                        else{

                                                          anzahl--;
                                                          entnehmenTextController.text = anzahl.toString();

                                                        }

                                                      } catch(e) {
                                                        entnehmenTextController.text = "0";
                                                      }

                                                      setState(() {});

                                                    }

                                                  },
                                                  child:


                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.black),
                                                      color: Colors.grey[100],
                                                    ),

                                                    child: const Icon(
                                                      Icons.arrow_left,
                                                      color: Colors.black,
                                                      size: 50,
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.15,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  color: Colors.grey[300],
                                                  child: TextField(
                                                    controller: entnehmenTextController,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 30,
                                                        fontWeight: FontWeight.normal),
                                                    textAlignVertical: TextAlignVertical.center,
                                                    maxLength: 25,
                                                    decoration: const InputDecoration(
                                                      contentPadding: EdgeInsets.only(),
                                                      filled: true,
                                                      fillColor: Colors.transparent,
                                                      counterText: "",
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                        borderSide:
                                                        BorderSide(color: Colors.transparent, width: 0.0),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                        borderSide:
                                                        BorderSide(color: Colors.transparent, width: 0.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                GestureDetector(
                                                  onTap: () {

                                                    if(loadedData){

                                                      try {

                                                        int anzahl = int.parse(entnehmenTextController.text);

                                                        if(anzahl<0 || anzahl > menge!["menge"]){
                                                          entnehmenTextController.text = "0";
                                                        }
                                                        else if(anzahl == menge["menge"]){
                                                        }
                                                        else{

                                                          anzahl++;
                                                          entnehmenTextController.text = anzahl.toString();

                                                        }

                                                      } catch(e) {
                                                        entnehmenTextController.text = "0";
                                                      }

                                                      setState(() {});

                                                    }

                                                  },
                                                  child:

                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.black),
                                                      color: Colors.grey[100],
                                                    ),

                                                    child: const Icon(
                                                      Icons.arrow_right,
                                                      color: Colors.black,
                                                      size: 50,
                                                    ),
                                                  ),
                                                ),

                                              ],)


                                          ],),
                                      ),
                                    ),

                                    ElevatedButton(
                                      onPressed: () async {

                                        if(loadedData){

                                          setState(() {
                                            loadedData = false;
                                          });

                                          if(checkUserInputEntnehmen(menge!["menge"])){

                                            // if(widget.selectedMenge.menge == int.parse(entnehmenTextController.text)){
                                            //   await deleteMenge(widget.selectedMenge);
                                            // }
                                            // else{
                                            //   await entnehmeMenge(widget.selectedMenge, widget.selectedMenge.menge - int.parse(entnehmenTextController.text.trim()));
                                            // }

                                          }
                                          else{

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
                                      style:
                                      ElevatedButton.styleFrom(
                                        foregroundColor:
                                        Colors.white,
                                        backgroundColor:
                                        Colors.green[300],
                                        side: const BorderSide(
                                            color: Colors.black,
                                            width: 1),
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                        ),
                                        // Text Color (Foreground color)
                                      ),
                                      child: const Text(
                                        'Entnehmen',
                                        style: TextStyle(fontSize: 25,),
                                      ),
                                    )

                                  ],
                                );

                            },
                          ),

                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: ElevatedButton(
                                onPressed: () {

                                  if(loadedData){

                                    print("Zurück!");

                                    entnehmenTextController.text = "0";

                                    Navigator.pop(context);

                                  }

                                },
                                style:
                                ElevatedButton.styleFrom(
                                  foregroundColor:
                                  Colors.white,
                                  backgroundColor:
                                  Colors.red[300],
                                  side: const BorderSide(
                                      color: Colors.black,
                                      width: 1),
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5),

                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        10),
                                  ),
                                  // Text Color (Foreground color)
                                ),
                                child: const Icon(
                                  Icons.arrow_back_outlined,
                                  size: 25,

                                  color: Colors.black,
                                ),
                              ),
                            ),

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

  bool checkUserInputEntnehmen(int selectedMenge) {

    errorMessage = "";

    if (entnehmenTextController.text.trim().isEmpty) {
      errorMessage += "Gebe eine Menge ein!\n";
    } else {
      try {
        int menge = int.parse(entnehmenTextController.text.trim());
        if (menge < 0) {
          errorMessage += "Die Menge darf nicht negativ sein!\n";
        }
        if (menge == 0) {
          errorMessage += "Die Menge darf nicht 0 sein!\n";
        }
        if (menge > selectedMenge) {
          errorMessage += "Du kannst höchstens $selectedMenge Artikel entnehmen!\n";
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

  // entnehmeMenge(MengeDTO mDTO, int menge) async {
  //
  //   LiveApiRequest<MengeDTO> liveApiRequest = LiveApiRequest<MengeDTO>(
  //       url: "https://artikelapp.000webhostapp.com/updateMenge.php");
  //   ApiResponse apiResponse = await liveApiRequest.executePost({
  //     "mengenID": mDTO.mengen_id.toString(),
  //     "menge": menge.toString(),
  //   });
  //   if (apiResponse.status == Status.SUCCESS) {
  //
  //     print("Menge erfolgreich entnommen!");
  //
  //     mDTO.menge = menge ;
  //
  //     int ist = 0;
  //     for (MengeDTO m in widget.selectedArticle.mengenListe!) {
  //       ist += m.menge;
  //     }
  //     widget.selectedArticle.istmenge = ist;
  //
  //     entnehmenTextController.text = "0";
  //     setState(() {
  //     });
  //
  //
  //   } else if (apiResponse.status == Status.EXCEPTION) {
  //     print("Exception!");
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       duration: Duration(seconds: 3),
  //       content: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.max,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
  //             child:
  //             Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
  //           ),
  //           Expanded(
  //             child: Padding(
  //               padding: EdgeInsets.all(5.0),
  //               child: Text(
  //                 "Server nicht erreichbar...\nPrüfe deine Internetverbindung!",
  //                 softWrap: true,
  //                 style: TextStyle(
  //                   height: 0,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.orange,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ));
  //   } else if (apiResponse.status == Status.ERROR) {
  //     print("Error!");
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       duration: Duration(seconds: 3),
  //       content: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.max,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
  //             child: Icon(color: Colors.red, size: 40, Icons.error_outlined),
  //           ),
  //           Expanded(
  //             child: Padding(
  //               padding: EdgeInsets.all(5.0),
  //               child: Text(
  //                 "Es ist ein Serverfehler aufgetreten!",
  //                 softWrap: true,
  //                 style: TextStyle(
  //                   height: 0,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.red,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ));
  //   }
  //
  // }
  //
  // deleteMenge(MengeDTO mengeDTO) async {
  //
  //   LiveApiRequest<MengeDTO> liveApiRequest = LiveApiRequest<MengeDTO>(
  //       url: "https://artikelapp.000webhostapp.com/deleteMenge.php");
  //   ApiResponse apiResponse = await liveApiRequest.executePost({
  //     "mengenID": mengeDTO.mengen_id.toString(),
  //   });
  //   if (apiResponse.status == Status.SUCCESS) {
  //
  //     print("Menge erfolgreich gelöscht!");
  //
  //     widget.selectedArticle.mengenListe!.remove(mengeDTO);
  //
  //     int ist = 0;
  //     for (MengeDTO m in widget.selectedArticle.mengenListe!) {
  //       ist += m.menge;
  //     }
  //     widget.selectedArticle.istmenge = ist;
  //
  //     Navigator.pop(context);
  //
  //   } else if (apiResponse.status == Status.EXCEPTION) {
  //     print("Exception!");
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       duration: Duration(seconds: 3),
  //       content: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.max,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
  //             child:
  //             Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
  //           ),
  //           Expanded(
  //             child: Padding(
  //               padding: EdgeInsets.all(5.0),
  //               child: Text(
  //                 "Server nicht erreichbar...\nPrüfe deine Internetverbindung!",
  //                 softWrap: true,
  //                 style: TextStyle(
  //                   height: 0,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.orange,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ));
  //   } else if (apiResponse.status == Status.ERROR) {
  //     print("Error!");
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       duration: Duration(seconds: 3),
  //       content: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.max,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
  //             child: Icon(color: Colors.red, size: 40, Icons.error_outlined),
  //           ),
  //           Expanded(
  //             child: Padding(
  //               padding: EdgeInsets.all(5.0),
  //               child: Text(
  //                 "Es ist ein Serverfehler aufgetreten!",
  //                 softWrap: true,
  //                 style: TextStyle(
  //                   height: 0,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.red,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ));
  //   }
  // }

  Widget getColorWidget(DocumentSnapshot menge, int warnzeit) {

    try {

      DateTime mengeDatum = (menge["datum"] as Timestamp).toDate();

      int differenceDates = HelperUtil.getDifferenceDates(mengeDatum.toString());

      if (differenceDates >= 0 && differenceDates > warnzeit && warnzeit !=-1) {
        return const Icon(
          Icons.check,
          color: Colors.green,
          size: 50,
        );
      } else if (differenceDates >= 0 && differenceDates <= warnzeit && warnzeit !=-1) {
        return const Icon(
          Icons.warning,
          color: Colors.orange,
          size: 50,
        );
      } else if (differenceDates < 0) {
        return const Icon(
          Icons.error,
          color: Colors.red,
          size: 50,
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

}





