import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:verwaltungsapp/dto/ArticleDTO.dart';
import 'package:verwaltungsapp/page/AddPage.dart';
import 'package:verwaltungsapp/widget/ArticleWidget.dart';
import '../dto/MengeDTO.dart';
import '../widget/FilterWidget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool loadedData = true;

  List<bool> filterList = [true, false, false, false, false];

  List<ArticleDTO> articleListSearch = <ArticleDTO>[];

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

                            // Filter articles by the search query
                            final filteredArticles = snapshot.data!.docs.where((doc) {

                              final name = doc['name'].toString().toLowerCase();

                              if(filterList[0]){
                                return name.contains(searchQuery);
                              }
                             else if(filterList[1]){
                                return name.contains(searchQuery) && doc["istmenge"] < doc["sollmenge"];
                              }
                             return name.contains(searchQuery);

                            }).toList();

                            return

                               filteredArticles.isEmpty

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
                                    itemCount: filteredArticles.length,
                                    itemBuilder: (context, index) {

                                      final article = filteredArticles[index];
                                      return ArticleWidget(article: article);

                                    }),
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


  bool isOKMenge(ArticleDTO article) {
    for (MengeDTO m in article.mengenListe!) {
      DateTime now = DateTime.now();
      DateTime datum = DateTime.parse(m.datum);

      DateTime nowFormated = DateTime(now.year, now.month, now.day);
      DateTime datumFormated = DateTime(datum.year, datum.month, datum.day);

      int difference =
          (datumFormated.difference(nowFormated).inHours / 24).round();
      // print("Difference: $difference Warnzeit: ${article.warnzeit}");

      if (article.warnzeit < difference) {
        return true;
      }
    }

    return false;
  }

  bool isWarningMenge(ArticleDTO article) {
    for (MengeDTO m in article.mengenListe!) {
      DateTime now = DateTime.now();
      DateTime datum = DateTime.parse(m.datum);

      DateTime nowFormated = DateTime(now.year, now.month, now.day);
      DateTime datumFormated = DateTime(datum.year, datum.month, datum.day);

      int difference =
          (datumFormated.difference(nowFormated).inHours / 24).round();
      // print("Difference: $difference Warnzeit: ${article.warnzeit}");

      if (difference >= 0 && article.warnzeit >= difference) {
        return true;
      }
    }

    return false;
  }

  bool isAbgelaufenMenge(ArticleDTO article) {
    for (MengeDTO m in article.mengenListe!) {
      DateTime now = DateTime.now();
      DateTime datum = DateTime.parse(m.datum);

      DateTime nowFormated = DateTime(now.year, now.month, now.day);
      DateTime datumFormated = DateTime(datum.year, datum.month, datum.day);

      int difference =
          (datumFormated.difference(nowFormated).inHours / 24).round();
      // print("Difference: $difference Warnzeit: ${article.warnzeit}");

      if (difference < 0) {
        return true;
      }
    }

    return false;
  }

}



