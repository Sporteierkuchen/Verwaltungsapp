import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../dto/UserDto.dart';
import '../util/PersistenceUtil.dart';
import 'WrapperPageState.dart';
import 'package:decimal/decimal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<_Article> articleList = <_Article>[];

 // late List<_Article> articleListSearch;
  List<_Article> articleListSearch= <_Article>[];

  int? selectedIndex;
  bool editarticleView = false;
  bool addarticleView = false;

  final fieldText = TextEditingController();
  final srollcontroller = ScrollController();

  final nameTextController = TextEditingController();
  final nummerTextController = TextEditingController();
  final beschreibungTextController = TextEditingController();
  final preisTextController = TextEditingController();
  final steuersatzTextController = TextEditingController();
  final scan_codeTextController = TextEditingController();

  bool loadedData = false;
  late UserDto? userDTo;

  @override
  void initState() {
    super.initState();
    print("Set State");

    loadData().whenComplete(() => setState(() {

      double price=3.345;
      for (var i = 0; i < 10; i++) {
        articleList.add(_Article(name: 'Testarticle ${i}', article_number: 'zjtfhxfgthxf', description: 'Das ist ein Test', price: price, steuersatz: 19, scan_code: 'fxngbgfgfn'));
        price+=34.67;
      }

      for (_Article a in articleList) {
          articleListSearch.add(a);
      }


//      articleListSearch = articleList;

          loadedData = true;
        }));
  }

  @override
  dispose() {
    print("Disposed");
    super.dispose();
    srollcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (loadedData) {

      return

        Scaffold(
            body: SafeArea(
                child:

                SingleChildScrollView(
                  controller: srollcontroller,
                  child:

                    getContent(),

                )));

    } else {
      return Container();
    }
  }

  Widget getContent(){

    if(editarticleView){

      return
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Text("Artikel bearbeiten",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),

                getAddArticleView(),

                const SizedBox(
                  height: 25,
                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment:
                  // MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty
                            .all<Color>(
                            Colors.grey),
                        foregroundColor:
                        MaterialStateProperty
                            .all<Color>(
                            Colors.black),
                        overlayColor:
                        MaterialStateProperty
                            .resolveWith<Color>(
                              (Set<MaterialState>
                          states) {
                            if (states.contains(
                                MaterialState
                                    .pressed)) {
                              return Colors
                                  .greenAccent; // Change this to desired press color
                            }
                            return Colors
                                .greenAccent; // Change this to desired press color
                          },
                        ),
                        shape: MaterialStateProperty
                            .all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(8),
                            side: BorderSide(
                                color: Color(
                                    0xFF222222)), // Border color and width
                          ),
                        ),
                        padding:
                        MaterialStateProperty
                            .all<EdgeInsets>(
                            EdgeInsets.all(
                                5)),
                        textStyle:
                        MaterialStateProperty
                            .all<TextStyle>(
                          TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // Flutter doesn't support transitions for state changes; you'd use animations for that.
                      ),
                      onPressed: () async {

                        articleList[selectedIndex!].name =nameTextController.text;
                        articleList[selectedIndex!].article_number=nummerTextController.text;
                        articleList[selectedIndex!].description=beschreibungTextController.text;
                        articleList[selectedIndex!].price=double.parse(preisTextController.text);
                        articleList[selectedIndex!].steuersatz=double.parse(steuersatzTextController.text);
                        articleList[selectedIndex!].scan_code=scan_codeTextController.text;

                        articleListSearch.clear();
                        for (_Article a in articleList) {
                          if (a.name.toLowerCase().contains(fieldText.text.toLowerCase().trim())) {
                            articleListSearch.add(a);
                          }
                        }

                        nameTextController.text="";
                        nummerTextController.text="";
                        beschreibungTextController.text="";
                        preisTextController.text="";
                        steuersatzTextController.text="";
                        scan_codeTextController.text="";

                        setState(() {
                          editarticleView = false;
                          srollcontroller.jumpTo(0);
                          selectedIndex = null;

                        });

                      },
                      label: Text("Speichern"),
                      icon: Icon(Icons.save),
                    ),

                    SizedBox(width: 50,),

                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty
                            .all<Color>(
                            Colors.grey),
                        foregroundColor:
                        MaterialStateProperty
                            .all<Color>(
                            Colors.black),
                        overlayColor:
                        MaterialStateProperty
                            .resolveWith<Color>(
                              (Set<MaterialState>
                          states) {
                            if (states.contains(
                                MaterialState
                                    .pressed)) {
                              return Colors
                                  .redAccent; // Change this to desired press color
                            }
                            return Colors
                                .redAccent; // Change this to desired press color
                          },
                        ),
                        shape: MaterialStateProperty
                            .all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(8),
                            side: BorderSide(
                                color: Color(
                                    0xFF222222)), // Border color and width
                          ),
                        ),
                        padding:
                        MaterialStateProperty
                            .all<EdgeInsets>(
                            EdgeInsets.all(
                                5)),
                        textStyle:
                        MaterialStateProperty
                            .all<TextStyle>(
                          TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // Flutter doesn't support transitions for state changes; you'd use animations for that.
                      ),
                      onPressed: () {

                        nameTextController.text="";
                        nummerTextController.text="";
                        beschreibungTextController.text="";
                        preisTextController.text="";
                        steuersatzTextController.text="";
                        scan_codeTextController.text="";

                        setState(() {
                          editarticleView = false;
                          srollcontroller.jumpTo(0);
                          selectedIndex = null;
                        });

                      },
                      label: Text("Abbrechen"),
                      icon: Icon(
                          Icons.cancel_outlined),
                    ),
                  ],
                ),

              ],),

        ],
        );

    }
    else if(addarticleView){

      return
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Text("Artikel hinzufügen",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),

                getAddArticleView(),

                const SizedBox(
                  height: 25,
                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment:
                  // MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty
                            .all<Color>(
                            Colors.grey),
                        foregroundColor:
                        MaterialStateProperty
                            .all<Color>(
                            Colors.black),
                        overlayColor:
                        MaterialStateProperty
                            .resolveWith<Color>(
                              (Set<MaterialState>
                          states) {
                            if (states.contains(
                                MaterialState
                                    .pressed)) {
                              return Colors
                                  .greenAccent; // Change this to desired press color
                            }
                            return Colors
                                .greenAccent; // Change this to desired press color
                          },
                        ),
                        shape: MaterialStateProperty
                            .all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(8),
                            side: BorderSide(
                                color: Color(
                                    0xFF222222)), // Border color and width
                          ),
                        ),
                        padding:
                        MaterialStateProperty
                            .all<EdgeInsets>(
                            EdgeInsets.all(
                                5)),
                        textStyle:
                        MaterialStateProperty
                            .all<TextStyle>(
                          TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // Flutter doesn't support transitions for state changes; you'd use animations for that.
                      ),
                      onPressed: () async {

                        articleList.add(_Article(name: nameTextController.text, article_number: nummerTextController.text, description: beschreibungTextController.text, price: double.parse(preisTextController.text), steuersatz: double.parse(steuersatzTextController.text), scan_code: scan_codeTextController.text));

                        articleListSearch.clear();
                        for (_Article a in articleList) {
                          if (a.name.toLowerCase().contains(fieldText.text.toLowerCase().trim())) {
                            articleListSearch.add(a);
                          }
                        }

                        nameTextController.text="";
                        nummerTextController.text="";
                        beschreibungTextController.text="";
                        preisTextController.text="";
                        steuersatzTextController.text="";
                        scan_codeTextController.text="";

                        setState(() {
                          addarticleView = false;
                          srollcontroller.jumpTo(0);
                        });

                      },
                      label: Text("Hinzufügen"),
                      icon: Icon(Icons.save),
                    ),

                    SizedBox(width: 50,),

                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty
                            .all<Color>(
                            Colors.grey),
                        foregroundColor:
                        MaterialStateProperty
                            .all<Color>(
                            Colors.black),
                        overlayColor:
                        MaterialStateProperty
                            .resolveWith<Color>(
                              (Set<MaterialState>
                          states) {
                            if (states.contains(
                                MaterialState
                                    .pressed)) {
                              return Colors
                                  .redAccent; // Change this to desired press color
                            }
                            return Colors
                                .redAccent; // Change this to desired press color
                          },
                        ),
                        shape: MaterialStateProperty
                            .all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(8),
                            side: BorderSide(
                                color: Color(
                                    0xFF222222)), // Border color and width
                          ),
                        ),
                        padding:
                        MaterialStateProperty
                            .all<EdgeInsets>(
                            EdgeInsets.all(
                                5)),
                        textStyle:
                        MaterialStateProperty
                            .all<TextStyle>(
                          TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // Flutter doesn't support transitions for state changes; you'd use animations for that.
                      ),
                      onPressed: () {

                        nameTextController.text="";
                        nummerTextController.text="";
                        beschreibungTextController.text="";
                        preisTextController.text="";
                        steuersatzTextController.text="";
                        scan_codeTextController.text="";

                        setState(() {
                          addarticleView = false;
                          srollcontroller.jumpTo(0);
                        });

                      },
                      label: Text("Abbrechen"),
                      icon: Icon(
                          Icons.cancel_outlined),
                    ),
                  ],
                ),

              ],),

          ],
        );

    }
    else{

      return Container(padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        height: (MediaQuery.of(context).orientation ==
            Orientation.portrait)
            ? MediaQuery.of(context).size.height * 0.91 -
            MediaQuery.of(context).padding.top
            : MediaQuery.of(context).size.height * 0.84 -
            MediaQuery.of(context).padding.top,

        child:

        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: 30,),

            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(
                  height: (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 50
                      : 40,
                  width: (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? MediaQuery.of(context).size.width * 0.7
                      : MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    controller: fieldText,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 18, decorationThickness: 0.0),
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 25,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      starteSuche(value);
                    },
                    onSubmitted: (value) {

                      starteSuche(value);
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

                          starteSuche(fieldText.text);
                        },
                        child: const Icon(
                          Icons.search_outlined,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            print("Suchfeld gecleart!");
                            //await _getCurrentPosition();

                            if(articleList.length != articleListSearch.length){
                              print("Artikellisten sind ungleich");

                              articleListSearch.clear();

                              for (_Article a in articleList) {
                                articleListSearch.add(a);
                              }

                            }
                            else{
                              print("Artikellisten sind gleich");
                            }

                            setState(() {
                              fieldText.clear();
                            });
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
                  child:
                  GestureDetector(
                      onTap: () {
                        print("Artikel hinzufügen!");

                        setState(() {
                          addarticleView =true;
                        });
                      },
                      child:
                      Icon(Icons.add_circle_outline_outlined,size: 40,)

                  ),
                ),

              ],),

            SizedBox(height: 30,),

            Expanded(child:

            articleList.isEmpty || articleListSearch.isEmpty
                ? Padding(
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
                :

            SlidableAutoCloseBehavior(
              closeWhenOpened: true,
              child: ListView.builder(
                //  shrinkWrap: true,
                // physics: const ScrollPhysics(),
                  itemCount: articleListSearch.length,
                  itemBuilder: (context, index) {
                    return
                      Slidable(

                        endActionPane: ActionPane(
                          extentRatio: 1,
                          motion: const DrawerMotion(),
                          children: [

                            SlidableAction(
                              autoClose: true,

                           borderRadius: BorderRadius.circular(10.0),
                              padding: EdgeInsets.all(5),
                              onPressed: (value) {

                                articleList.removeAt(articleList.indexOf(articleListSearch[index]));

                                articleListSearch.clear();
                                for (_Article a in articleList) {
                                  if (a.name.toLowerCase().contains(fieldText.text.toLowerCase().trim())) {
                                    articleListSearch.add(a);
                                  }
                                }

                                 setState(() {});
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
                          print(
                              "Ausgewählter Artikel: ${articleListSearch[index].name}");

                          selectedIndex = articleList.indexOf(articleListSearch[index]);

                          nameTextController.text =articleList[selectedIndex!].name ;
                          nummerTextController.text = articleList[selectedIndex!].article_number;
                          beschreibungTextController.text = articleList[selectedIndex!].description;
                          preisTextController.text =roundDouble(articleList[selectedIndex!].price, 2).toString();
                          steuersatzTextController.text = articleList[selectedIndex!].steuersatz.toString();
                          scan_codeTextController.text = articleList[selectedIndex!].scan_code;

                          setState(() {
                            editarticleView = true;
                          });

                        },

                        child:

                        Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                             margin: const EdgeInsets.all(5),
                            elevation: 3,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding:
                                  EdgeInsets.only(left: 10, right: 15, top: 20, bottom: 20),
                                  child: Icon(color: Colors.grey, size: 40, Icons.article_outlined),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          articleListSearch[index].name,
                                          style: TextStyle(
                                            height: 0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Artikelnummer: "+articleListSearch[index].article_number,
                                          style: TextStyle(
                                            height: 0,
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  color: Color(0xFF7B1A33),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  margin: EdgeInsets.only(left: 15, right: 8, top: 20, bottom: 20),
                                  elevation: 3,
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                    child: Text(roundDouble(articleListSearch[index].price, 2).toString()+"€",
                                      style: TextStyle(
                                        height: 0,
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                    ),
                      );
                  }),
            ),


            ),

            SizedBox(height: 5,),

          ],
        ),

      );
    }

  }

 Widget getAddArticleView(){

return
  Column(children: [

    Row(
      children: [
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.35
              : MediaQuery.of(context)
              .size
              .width *
              0.2,
          child: Padding(
            padding:
            const EdgeInsets.only(
                right: 5),
            child: Text("Artikelname" +
                ":",
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.48
              : MediaQuery.of(context)
              .size
              .width *
              0.6,
          height: 30,
          child: TextField(
            controller:
            nameTextController,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight:
                FontWeight.normal),
            textAlignVertical:
            TextAlignVertical
                .center,
            maxLength: 25,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets
                  .only(),
              filled: true,
              fillColor:
              Colors.grey[100],
              counterText: "",
              focusedBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              enabledBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              hintText: "Artikelname" +
                  "...",
            ),
          ),
        ),
      ],
    ),
    const SizedBox(
      height: 10,
    ),
    Row(
      children: [
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.35
              : MediaQuery.of(context)
              .size
              .width *
              0.2,
          child: Padding(
            padding:
            const EdgeInsets.only(
                right: 5),
            child: Text("Artikelnummer" +
                ":",
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.48
              : MediaQuery.of(context)
              .size
              .width *
              0.6,
          height: 30,
          child: TextField(
            controller:
            nummerTextController,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight:
                FontWeight.normal),
            textAlignVertical:
            TextAlignVertical
                .center,
            maxLength: 25,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets
                  .only(),
              filled: true,
              fillColor:
              Colors.grey[100],
              counterText: "",
              focusedBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              enabledBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              hintText:"Artikelnummer" +
                  "...",
            ),
          ),
        ),
      ],
    ),
    const SizedBox(
      height: 10,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.35
              : MediaQuery.of(context)
              .size
              .width *
              0.2,
          child: Padding(
            padding:
            const EdgeInsets.only(
                right: 5),
            child: Text("Beschreibung" +
                ":",
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.48
              : MediaQuery.of(context)
              .size
              .width *
              0.6,
          height: 60,
          child: TextField(
            controller:
            beschreibungTextController,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight:
                FontWeight.normal),
            textAlignVertical:
            TextAlignVertical
                .center,
            // maxLength: 25,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets
                  .only(),
              filled: true,
              fillColor:
              Colors.grey[100],
              counterText: "",
              focusedBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              enabledBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              hintText: "Beschreibung" +
                  "...",
            ),
          ),
        ),
      ],
    ),
    const SizedBox(
      height: 10,
    ),
    Row(
      children: [
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.35
              : MediaQuery.of(context)
              .size
              .width *
              0.2,
          child: Padding(
            padding:
            const EdgeInsets.only(
                right: 5),
            child: Text("Preis in €" +
                ":",
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.48
              : MediaQuery.of(context)
              .size
              .width *
              0.6,
          height: 30,
          child: TextField(
            controller:
            preisTextController,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight:
                FontWeight.normal),
            textAlignVertical:
            TextAlignVertical
                .center,
            maxLength: 25,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets
                  .only(),
              filled: true,
              fillColor:
              Colors.grey[100],
              counterText: "",
              focusedBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              enabledBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              hintText: "Preis" +
                  "...",
            ),
          ),
        ),
      ],
    ),
    const SizedBox(
      height: 10,
    ),
    Row(
      children: [
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.35
              : MediaQuery.of(context)
              .size
              .width *
              0.2,
          child: Padding(
            padding:
            const EdgeInsets.only(
                right: 5),
            child: Text("Steuersatz in %" +
                ":",
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.48
              : MediaQuery.of(context)
              .size
              .width *
              0.6,
          height: 30,
          child: TextField(
            controller:
            steuersatzTextController,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight:
                FontWeight.normal),
            textAlignVertical:
            TextAlignVertical
                .center,
            maxLength: 25,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets
                  .only(),
              filled: true,
              fillColor:
              Colors.grey[100],
              counterText: "",
              focusedBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              enabledBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              hintText: "Steuersatz" +
                  "...",
            ),
          ),
        ),
      ],
    ),
    const SizedBox(
      height: 10,
    ),
    Row(
      children: [
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.35
              : MediaQuery.of(context)
              .size
              .width *
              0.2,
          child: Padding(
            padding:
            const EdgeInsets.only(
                right: 5),
            child: Text("Scan-Code" +
                ":",
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context)
              .orientation ==
              Orientation.portrait)
              ? MediaQuery.of(context)
              .size
              .width *
              0.48
              : MediaQuery.of(context)
              .size
              .width *
              0.6,
          height: 30,
          child: TextField(
            controller:
            scan_codeTextController,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight:
                FontWeight.normal),
            textAlignVertical:
            TextAlignVertical
                .center,
            maxLength: 25,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets
                  .only(),
              filled: true,
              fillColor:
              Colors.grey[100],
              counterText: "",
              focusedBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              enabledBorder:
              const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        0.0)),
                borderSide: BorderSide(
                    color: Colors
                        .transparent,
                    width: 0.0),
              ),
              hintText: "Scan-Code" +
                  "...",
            ),
          ),
        ),
      ],
    ),


  ],);

 }


  void starteSuche(String value) {
    print("Artikelsuche gestartet! Value: $value");

    if (value.trim().isNotEmpty) {
      articleListSearch.clear();

      for (_Article a in articleList) {
        if (a.name.toLowerCase().contains(value.toLowerCase().trim())) {
          print("Beschreibung " + a.name);

          articleListSearch.add(a);
        }
      }

      setState(() {
      });

    }
    else{

      if(articleList.length != articleListSearch.length){
        print("Artikellisten sind ungleich");

        articleListSearch.clear();

        for (_Article a in articleList) {
          articleListSearch.add(a);
        }

        setState(() {
        });

      }
      else{
        print("Artikellisten sind gleich");
      }

    }

  }


  Future<void> loadData() async {
    await PersistenceUtil.getUser().then((value) => setState(() {
          userDTo = value;
        }));

  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

}

class _Article {
  _Article({

    required this.name,
    required this.article_number,
    required this.description,
    required this.price,
    required this.steuersatz,
    required this.scan_code,

  });

   String name;
   String article_number;
   String description;
   double price;
   double steuersatz;
   String scan_code;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return (other is _Article &&
        other.runtimeType == runtimeType &&

        other.name == name &&
        other.description == description);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(name,
      description);
}