import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class HomePageState extends WrapperPageState<HomePage> {
  List<_Article> articleList = <_Article>[];

  final fieldText = TextEditingController();
  final srollcontroller = ScrollController();

  bool loadedData = false;
  late UserDto? userDTo;

  @override
  void initState() {
    super.initState();
    print("Set State");

    loadData().whenComplete(() => setState(() {

      for (var i = 0; i < 10; i++) {
        articleList.add(_Article(name: 'Testarticle', article_number: '34gf', description: 'Das ist ein Test', price: 10.67, steuersatz: 19, scan_code: 'fxngbgfgfn'));
      }


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
  Widget getContent() {
    if (loadedData) {
      return

        Column(
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
                        ? MediaQuery.of(context).size.width * 0.8
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
                        // await _getCurrentPosition();
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
                            //await _getCurrentPosition();
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
                              setState(() {
                                // mapWithoutSearchedLocations = true;
                                // showAllResults = false;
                                // mapLoaded = false;
                                fieldText.clear();
                                // _locationsFound.clear();
                                // updatePageviewsSelectedPage = true;
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

              ],),

              SizedBox(height: 30,),

              articleList.isEmpty
                  ? Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                    "leer",
              ))
                  : ListView.builder(
                  //shrinkWrap: true,
                 // physics: const ScrollPhysics(),
                  itemCount: articleList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print(
                            "Ausgewählter Artikel: ${articleList[index].name}");

                        // setState(() {
                        //   if (isLocationavailable()) {
                        //     _currentSelectedIndex = index + 1;
                        //   } else {
                        //     _currentSelectedIndex = index;
                        //   }
                        //
                        //   mapLoaded = false;
                        //   mapWithoutSearchedLocations = false;
                        //   updatePageviewsSelectedPage = true;
                        // });
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
                                child: Icon(color: Colors.grey, size: 30, Icons.article_outlined),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        articleList[index].name,
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
                                        "",
                                        style: TextStyle(
                                          height: 0,
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                      "€",
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
                                margin: EdgeInsets.only(left: 10, right: 8, top: 20, bottom: 20),
                                elevation: 3,
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                  child: Text(
                                    "n",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    );
                  }),

              SizedBox(height: 5,),

            ],
        );

    } else {
      return Container();
    }
  }

  void starteSuche(String value) {
    print("Ortssuche gestartet! Value: $value");

    if (value.trim().isNotEmpty) {
      // _locationsFound.clear();
      //
      // for (_LocationDetails d in _locations) {
      //   if (d.continent.toLowerCase().contains(value.toLowerCase().trim()) ||
      //       d.country.toLowerCase().contains(value.toLowerCase().trim()) ||
      //       d.state.toLowerCase().contains(value.toLowerCase().trim()) ||
      //       d.town.toLowerCase().contains(value.toLowerCase().trim()) ||
      //       d.adress.toLowerCase().contains(value.toLowerCase().trim()) ||
      //       d.name.toLowerCase().contains(value.toLowerCase().trim())) {
      //     print("Beschreibung " + d.name);
      //
      //     _locationsFound.add(d);
      //   }
      // }
    }

    setState(() {
      // mapLoaded = false;
      // mapWithoutSearchedLocations = true;
      // showAllResults = false;
      // updatePageviewsSelectedPage = true;
    });
  }


  Future<void> loadData() async {
    await PersistenceUtil.getUser().then((value) => setState(() {
          userDTo = value;
        }));

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

  final String name;
  final String article_number;
  final String description;
  final double price;
  final double steuersatz;
  final String scan_code;

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