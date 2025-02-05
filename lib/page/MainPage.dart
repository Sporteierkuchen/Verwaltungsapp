import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:verwaltungsapp/page/AddPage.dart';
import 'package:verwaltungsapp/widget/ArticleWidget.dart';
import '../util/HelperUtil.dart';
import '../widget/FilterWidget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool loadedData = true;

  List<bool> filterList = [true, false, false, false, false];

  final fieldText = TextEditingController();
  String searchQuery = ""; // To filter articles by search

  @override
  void initState() {
    super.initState();
    print("Init State MainPage");

  }

  @override
  dispose() {
    print("Disposed MainPage");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("Build MainPage");

      return
        PopScope(
          canPop: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false ,
            body: SafeArea(
                child:
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.7,

                            child: TextField(
                              controller: fieldText,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  decorationThickness: 0.0),
                              textAlignVertical: TextAlignVertical.center,
                              maxLength: 25,
                              textInputAction: TextInputAction.search,
                              onChanged: (value) {
                                if (loadedData) {

                                  setState(() {
                                    searchQuery = value.toLowerCase().trim(); // Update search query
                                  });

                                }
                              },
                              onSubmitted: (value) {
                                if (loadedData) {

                                  setState(() {
                                    searchQuery = value.toLowerCase().trim(); // Update search query
                                  });

                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(),
                                filled: true,
                                fillColor: Colors.white,
                                counterText: "",
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                ),
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    if (loadedData) {

                                      setState(() {
                                        searchQuery = fieldText.text.toLowerCase().trim(); // Update search query
                                      });

                                    }
                                  },
                                  child: const Icon(
                                    Icons.search_outlined,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      if (loadedData) {
                                        print("Suchfeld gecleart!");

                                        fieldText.clear();

                                        setState(() {
                                          searchQuery = ""; // Update search query
                                        });

                                      }
                                    },
                                    child: const Icon(
                                      Icons.close_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    )),
                                hintText: "Suche...",
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: GestureDetector(
                                onTap: () {
                                  if (loadedData) {
                                    print("Artikel hinzufügen!");

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AddPage(),
                                      ),
                                    ).then((value) => setState(() {}));

                                  }
                                },
                                child: const Icon(
                                  Icons.add_circle_outline_outlined,
                                  size: 40,
                                )),
                          ),

                        ],
                      ),

                      Row(
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(left: 20, bottom: 20, top: 5),
                            child: GestureDetector(
                                onTap: () async {
                                  if (loadedData) {

                                    setState(() {
                                      loadedData = false;
                                    });

                                    await  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog(isChecked: filterList);
                                      },
                                    );
                                    print(filterList);

                                    setState(() {
                                      loadedData = true;
                                    });

                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  child: const Row(children: [

                                    Icon(
                                      Icons.filter_list,
                                      size: 25,

                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      "Filter",
                                      softWrap: true,
                                      style: TextStyle(
                                        height: 0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),

                                  ],),
                                )
                            ),
                          ),

                        ],
                      ),

                      Expanded(
                        child:

                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.
                          collection('Article').
                          orderBy("name").
                          snapshots(),// Echtzeit-Stream für Benutzer-Dokument

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

                            }

                            if (snapshot.data == null) {
                              return  Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: LoadingAnimationWidget.progressiveDots(
                                          color: const Color(0xFF7B1A33),
                                          size: 100,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                            }

                            final filteredArticlesWithName = snapshot.data!.docs.where((doc) {

                              final name = doc['name'].toString().toLowerCase();
                              return name.contains(searchQuery);

                            }).toList();

                            return

                              FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
                                future: _filterArtikel(filteredArticlesWithName),
                                builder: (context, filterSnapshot) {

                                  if (filterSnapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Error: ${snapshot.error}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.red)),
                                    );
                                  }
                                  if (filterSnapshot.connectionState == ConnectionState.waiting) {
                                   // return const Center(child: CircularProgressIndicator());
                                  }
                                  if (filterSnapshot.data == null) {
                                    return  Container(
                                      color: Colors.white,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: LoadingAnimationWidget.progressiveDots(
                                              color: const Color(0xFF7B1A33),
                                              size: 100,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  List<QueryDocumentSnapshot<Object?>> gefilterteArtikel = filterSnapshot.data!;

                                  return

                                    gefilterteArtikel.isEmpty

                                      ? const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        "Keine Artikel vorhanden!",
                                        style: TextStyle(
                                          height: 0,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ))
                                      : SlidableAutoCloseBehavior(
                                    closeWhenOpened: true,
                                    child: ListView.builder(
                                        itemCount: gefilterteArtikel.length,
                                        itemBuilder: (context, index) {

                                          final article = gefilterteArtikel[index];
                                          return ArticleWidget(article: article);

                                        }),
                                  );

                                },
                              );

                          },
                        ),

                      ),

                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
            ),
                ),
        );

  }

  Future<List<QueryDocumentSnapshot<Object?>>> _filterArtikel(List<QueryDocumentSnapshot<Object?>> artikel)  async {

    if (filterList[0]) {
      return artikel; // Keine Filter anwenden -> Alle Artikel anzeigen
    }

    List<QueryDocumentSnapshot<Object?>> gefilterteArtikel = [];

    for (var doc in artikel) {

      var data = doc.data() as Map<String, dynamic>;
      String artikelId = doc.id;
      int istmenge = data["istmenge"];
      int sollmenge = data["sollmenge"];
      int warnzeit = data["warnzeit"];

      bool addArtikel = true;

      if (filterList[1] && istmenge >= sollmenge) {
        addArtikel = false;
      }

      if (filterList[4] &&
          !(await _hatAbgelaufeneMenge(artikelId))) {
        addArtikel = false;
      }

      if (filterList[3] &&
          !(await _hatMengeMitWarnzeit(artikelId, warnzeit))) {
        addArtikel = false;
      }

      if (filterList[2] && !(await _hatMengeOk(artikelId, warnzeit))) {
        addArtikel = false;
      }

      if (addArtikel) {
        gefilterteArtikel.add(doc);
      }
    }

    return gefilterteArtikel;
  }

  // 🔍 Prüft, ob ein Artikel eine Menge mit abgelaufenem Datum hat
  Future<bool> _hatAbgelaufeneMenge(String artikelId) async {

    List<QueryDocumentSnapshot<Object?>> mengen = await _getMengenArtikel(artikelId);

    return mengen.any((menge) {

      var data = menge.data() as Map<String, dynamic>;
      DateTime mengeDatum = (data["datum"] as Timestamp).toDate();

      int differenceDates = HelperUtil.getDifferenceDates(mengeDatum.toString());
      return differenceDates < 0;

    });

  }

  // 🔍 Prüft, ob ein Artikel Mengen innerhalb/außerhalb der Warnzeit hat
  Future<bool> _hatMengeMitWarnzeit(String artikelId, int warnzeit) async {

  List<QueryDocumentSnapshot<Object?>> mengen = await _getMengenArtikel(artikelId);

  return mengen.any((menge) {

  var data = menge.data() as Map<String, dynamic>;
  DateTime mengeDatum = (data["datum"] as Timestamp).toDate();
  int differenceDates = HelperUtil.getDifferenceDates(mengeDatum.toString());

  return differenceDates >= 0 && differenceDates <= warnzeit && warnzeit != -1;

  });

  }

  // 🔍 Prüft, ob ein Artikel Mengen innerhalb/außerhalb der Warnzeit hat
  Future<bool> _hatMengeOk(String artikelId, int warnzeit) async {

    List<QueryDocumentSnapshot<Object?>> mengen = await _getMengenArtikel(artikelId);

    return mengen.any((menge) {

      var data = menge.data() as Map<String, dynamic>;
      DateTime mengeDatum = (data["datum"] as Timestamp).toDate();
      int differenceDates = HelperUtil.getDifferenceDates(mengeDatum.toString());

        return differenceDates >= 0 && differenceDates > warnzeit && warnzeit != -1;

    });

  }

  // 🔥 Firebase-Abfrage für Mengen mit einer bestimmten artikelId
  Future<List<QueryDocumentSnapshot<Object?>>> _getMengenArtikel(String artikelId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("Menge")
      .where("artikelId", isEqualTo: artikelId)
      .get();

  return snapshot.docs;
  }

}



