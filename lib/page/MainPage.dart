

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:verwaltungsapp/dto/ArticleDTO.dart';
import '../util/LiveApiRequest.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {

  //List<_Article> articleList = <_Article>[];

  List<ArticleDTO> articleList2 = [];
  List<ArticleDTO> articleListSearch= <ArticleDTO>[];

  int? selectedIndex;
  bool editarticleView = false;
  bool addarticleView = false;

  final fieldText = TextEditingController();
  final srollcontroller = ScrollController();


  String image = "";
  final nameTextController = TextEditingController();
  final sollmengeTextController = TextEditingController();
  final warnzeitTextController = TextEditingController();

  bool loadedData = false;

  String errorMessage= "";

  @override
  void initState() {
    super.initState();
    print("Init State");

    loadData().whenComplete(() => setState(() {

      for (ArticleDTO a in articleList2) {
        articleListSearch.add(a);
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
  Widget build(BuildContext context) {

    if (loadedData) {

      return

        Scaffold(

         //resizeToAvoidBottomInset: false ,
            body: SafeArea(
                child:

                SingleChildScrollView(
                  controller: srollcontroller,
                  child:

                  getContent(),

                )));

    } else {
      return SafeArea(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: LoadingAnimationWidget.prograssiveDots(
                  color: const Color(0xFF7B1A33),
                  size: 100,
                ),
              ),
            ],
          ),
        ),
      );
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

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
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

                        // articleList[selectedIndex!].name =nameTextController.text;
                        // articleList[selectedIndex!].article_number=nummerTextController.text;
                        // articleList[selectedIndex!].description=beschreibungTextController.text;
                        // articleList[selectedIndex!].price=double.parse(preisTextController.text);
                        // articleList[selectedIndex!].steuersatz=int.parse(steuersatz.replaceAll("%", ""));
                        // articleList[selectedIndex!].scan_code=scan_codeTextController.text;
                        //
                        // articleListSearch.clear();
                        // for (_Article a in articleList) {
                        //   if (a.name.toLowerCase().contains(fieldText.text.toLowerCase().trim())) {
                        //     articleListSearch.add(a);
                        //   }
                        // }
                        //
                        // nameTextController.text="";
                        // nummerTextController.text="";
                        // beschreibungTextController.text="";
                        // preisTextController.text="";
                        // steuersatz="";
                        // scan_codeTextController.text="";
                        //
                        // setState(() {
                        //   editarticleView = false;
                        //   srollcontroller.jumpTo(0);
                        //   selectedIndex = null;
                        //
                        // });

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
                        sollmengeTextController.text="";
                        warnzeitTextController.text="";

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

                const Padding(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 5),
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
                            side: const BorderSide(
                                color: Color(
                                    0xFF222222)), // Border color and width
                          ),
                        ),
                        padding:
                        MaterialStateProperty
                            .all<EdgeInsets>(
                            const EdgeInsets.all(
                                5)),
                        textStyle:
                        MaterialStateProperty
                            .all<TextStyle>(
                          const TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // Flutter doesn't support transitions for state changes; you'd use animations for that.
                      ),
                      onPressed: () async {

                        if(loadedData){

                          loadedData = false;

                          if(checkUserInputArticle()){
                            await addArticle();
                          }
                          else{
                            print("Fehler Eingabe!");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      duration: Duration(seconds: 3),
                                      content:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
                                            child: Icon(color: Colors.orangeAccent, size: 40, Icons.warning_outlined),
                                          ),
                                          Expanded(
                                            child:

                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Text(errorMessage,
                                                softWrap: true,
                                                style: const TextStyle(
                                                  height: 0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orangeAccent,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ));
                                loadedData = true;
                          }


                        }

                      },
                      label: const Text("Hinzufügen"),
                      icon: const Icon(Icons.save),
                    ),

                    const SizedBox(width: 50,),

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
                            side: const BorderSide(
                                color: Color(
                                    0xFF222222)), // Border color and width
                          ),
                        ),
                        padding:
                        MaterialStateProperty
                            .all<EdgeInsets>(
                            const EdgeInsets.all(
                                5)),
                        textStyle:
                        MaterialStateProperty
                            .all<TextStyle>(
                          const TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // Flutter doesn't support transitions for state changes; you'd use animations for that.
                      ),
                      onPressed: () {

                        if(loadedData){

                          print("Abbrechen!");
                          image="";
                          nameTextController.text="";
                          sollmengeTextController.text="";
                          warnzeitTextController.text="";

                          setState(() {
                            addarticleView = false;
                            srollcontroller.jumpTo(0);
                          });

                        }

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
        height:  MediaQuery.of(context).size.height- MediaQuery.of(context).padding.top,
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

                      if(loadedData){
                        starteSuche(value);
                      }

                    },
                    onSubmitted: (value) {

                      if(loadedData){
                        starteSuche(value);
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

                          if(loadedData){

                            starteSuche(fieldText.text);

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

                            if(loadedData){

                              print("Suchfeld gecleart!");
                              //await _getCurrentPosition();

                              if(articleList2.length != articleListSearch.length){
                                print("Artikellisten sind ungleich");

                                articleListSearch.clear();

                                for (ArticleDTO a in articleList2) {
                                  articleListSearch.add(a);
                                }

                              }
                              else{
                                print("Artikellisten sind gleich");
                              }

                              setState(() {
                                fieldText.clear();
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
                  child:
                  GestureDetector(
                      onTap: () {

                        if(loadedData){

                          print("Artikel hinzufügen!");

                          setState(() {
                            addarticleView =true;
                          });

                        }

                      },
                      child:
                      const Icon(Icons.add_circle_outline_outlined,size: 40,)

                  ),
                ),

              ],),

            SizedBox(height: 30,),

            Expanded(child:

            articleList2.isEmpty || articleListSearch.isEmpty
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

                                if(loadedData){
                                  loadedData = false;




                                }

                                // articleList.removeAt(articleList.indexOf(articleListSearch[index]));
                                //
                                // articleListSearch.clear();
                                // for (_Article a in articleList) {
                                //   if (a.name.toLowerCase().contains(fieldText.text.toLowerCase().trim())) {
                                //     articleListSearch.add(a);
                                //   }
                                // }
                                //
                                //  setState(() {});
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

                            // selectedIndex = articleList.indexOf(articleListSearch[index]);
                            //
                            // nameTextController.text =articleList[selectedIndex!].name ;
                            // nummerTextController.text = articleList[selectedIndex!].article_number;
                            // beschreibungTextController.text = articleList[selectedIndex!].description;
                            // preisTextController.text =roundDouble(articleList[selectedIndex!].price, 2).toString();
                            // steuersatz = articleList[selectedIndex!].steuersatz.toString()+"%";
                            // scan_codeTextController.text = articleList[selectedIndex!].scan_code;
                            //
                            // setState(() {
                            //   editarticleView = true;
                            // });

                          },

                          child:

                          Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: const EdgeInsets.all(5),
                              elevation: 3,
                              child:

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [

                                    Container(
                                      padding: EdgeInsets.all(2), // Border width
                                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                      child:
                                      ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(35), // Image radius
                                          child:
                                          articleList2[index].logo.isEmpty ?
                                          Image.asset("lib/images/articles/empty.png", fit: BoxFit.cover)
                                              :
                                          Image.memory(base64Decode(articleList2[index].logo), fit: BoxFit.cover,

                                          gaplessPlayback: true,
                                             // filterQuality: FilterQuality.high,

                                          ),
                                        ),
                                      ),

                                    ),

                                    SizedBox(width: 10,),

                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text(
                                              articleListSearch[index].name,
                                              style: const TextStyle(
                                                height: 0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),

                                            Row(children: [

                                              Text(
                                                "Soll: ${articleListSearch[index].sollmenge}",
                                                style: const TextStyle(
                                                  height: 0,
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Ist: ${articleListSearch[index].istmenge ?? 0}",
                                                style: const TextStyle(
                                                  height: 0,
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),

                                            ],),

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
                                      child: const Padding(
                                        padding:
                                        EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                        child: Text("€",
                                          style: TextStyle(
                                            height: 0,
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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

        Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3),
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
                child:

                ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(100), // Image radius
                    child:

                    image.isNotEmpty
                        ? Image.memory(
                      base64Decode(image),
                      fit: BoxFit.cover,

                      gaplessPlayback: true,
                      // filterQuality: FilterQuality.high,

                    )
                        : Image.asset(
                      "lib/images/articles/empty.png",
                      fit: BoxFit.cover,

                    ),

                  ),
                ),

              ),




              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 10, right: 20),
                    child: GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: Container(
                          color: Colors.grey,
                          child: const Row(
                            children: [
                              Icon(Icons.edit_outlined),
                              Icon(Icons.image_outlined),
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        pickImageC();
                      },
                      child: Container(
                          color: Colors.grey,
                          child: const Row(
                            children: [
                              Icon(Icons.edit_outlined),
                              Icon(Icons.camera_alt_outlined),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),


        const SizedBox(height: 30,),

        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context)
                  .size
                  .width *
                  0.35,

              child: const Padding(
                padding:
                EdgeInsets.only(
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
              width:  MediaQuery.of(context)
                  .size
                  .width *
                  0.48,

              height: 30,
              child: TextField(
                controller:
                nameTextController,
                style: const TextStyle(
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
              width: MediaQuery.of(context)
                  .size
                  .width *
                  0.35,

              child: const Padding(
                padding:
                EdgeInsets.only(
                    right: 5),
                child: Text("Sollmenge" +
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
              width: MediaQuery.of(context)
                  .size
                  .width *
                  0.48,

              height: 30,
              child: TextField(
                controller:
                sollmengeTextController,
                style: const TextStyle(
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
                  hintText:"Sollmenge" +
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width:  MediaQuery.of(context)
                  .size
                  .width *
                  0.35,

              child: const Padding(
                padding:
                EdgeInsets.only(
                    right: 5),
                child: Text("Warnzeit in Tagen" +
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
              width: MediaQuery.of(context)
                  .size
                  .width *
                  0.48,

              height: 30,
              child: TextField(
                controller:
                warnzeitTextController,
                style: const TextStyle(
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
                  hintText: "Warnzeit in Tagen" +
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

      for (ArticleDTO a in articleList2) {
        if (a.name.toLowerCase().contains(value.toLowerCase().trim())) {
          print("Beschreibung ${a.name}");

          articleListSearch.add(a);
        }
      }

      setState(() {
      });

    }
    else{

      if(articleList2.length != articleListSearch.length){
        print("Artikellisten sind ungleich");

        articleListSearch.clear();

        for (ArticleDTO a in articleList2) {
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


    await loadArticles();


  }

  loadArticles() async{

    LiveApiRequest<ArticleDTO> liveApiRequest =
    LiveApiRequest<ArticleDTO>(url: "https://artikelapp.000webhostapp.com/getArticle.php");
    ApiResponse apiResponse = await liveApiRequest.executeGet();
    if (apiResponse.status == Status.SUCCESS) {

      print("Artikel erfolgreich geladen!");

      List<ArticleDTO>.from(jsonDecode(apiResponse.body!)
          .map((model) => ArticleDTO.fromJson(model))).forEach((element) {
        articleList2.add(element);
      });


    } else if (apiResponse.status == Status.EXCEPTION) {
    } else if (apiResponse.status == Status.ERROR) {
    }

  }

  addArticle() async{

    LiveApiRequest<ArticleDTO> liveApiRequest =
    LiveApiRequest<ArticleDTO>(url: "https://artikelapp.000webhostapp.com/addArticle.php");
    ApiResponse apiResponse = await liveApiRequest.executePost({
      "logo": image,
      "name": nameTextController.text.trim(),
      "sollmenge": sollmengeTextController.text.trim(),
      "warnzeit": warnzeitTextController.text.trim(),

    });
    if (apiResponse.status == Status.SUCCESS) {

      print("Artikel erfolgreich hinzugefügt!");

      int article_id = int.parse(apiResponse.body!);

      articleList2.add(ArticleDTO(artikel_id: article_id, logo: image, name: nameTextController.text.trim(), sollmenge: int.parse(sollmengeTextController.text.trim()), warnzeit: int.parse(warnzeitTextController.text.trim())));

      articleListSearch.clear();
      for (ArticleDTO a in articleList2) {
        if (a.name.toLowerCase().contains(fieldText.text.toLowerCase().trim())) {
          articleListSearch.add(a);
        }
      }

      setState(() {

        loadedData = true;

        image="";
        nameTextController.text="";
        sollmengeTextController.text="";
        warnzeitTextController.text="";

        addarticleView = false;
        srollcontroller.jumpTo(0);
      });


    } else if (apiResponse.status == Status.EXCEPTION) {
      print("Exception!");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child: Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
            ),
            Expanded(
              child:

              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("Server nicht erreichbar...\nPrüfe deine Internetverbindung!",
                  softWrap: true,
                  style: TextStyle(
                    height: 0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),

      ));
        loadedData = true;
    } else if (apiResponse.status == Status.ERROR) {
      print("Error!");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child: Icon(color: Colors.red, size: 40, Icons.error_outlined),
            ),
            Expanded(
              child:

              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("Es ist ein Serverfehler aufgetreten!",
                  softWrap: true,
                  style: TextStyle(
                    height: 0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),

      ));
        loadedData = true;
    }

  }




  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Future pickImage() async {

    if(loadedData){

      try {
        final image = await ImagePicker().pickImage(source: ImageSource.gallery);

        if (image == null) return;

        setState(() {

          List<int> imageBytes = File(image.path).readAsBytesSync();
          this.image = base64Encode(imageBytes);

        });



      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }

    }

  }

  Future pickImageC() async {

    if(loadedData){

      try {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);

        if (image == null) return;

        setState(() {

          List<int> imageBytes = File(image.path).readAsBytesSync();
          this.image = base64Encode(imageBytes);

        });

      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }

    }

  }

  bool checkUserInputArticle() {

    errorMessage = "";

    if(nameTextController.text.trim().isEmpty){
      errorMessage+= "Gebe einen Artikelnamen ein!\n";
    }

    if(sollmengeTextController.text.trim().isEmpty){
      errorMessage+= "Gebe die Sollmenge ein!\n";
    }
    else{
      try {
        int sollmenge = int.parse(sollmengeTextController.text.trim());
        if(sollmenge <0){
          errorMessage+= "Die Sollmenge darf nicht negativ sein!\n";
        }
      } catch(e) {
        errorMessage+= "Die Sollmenge muss eine Zahl sein!\n";
      }
    }

    if(warnzeitTextController.text.trim().isEmpty){
      errorMessage+= "Gebe die Warnzeit ein!\n";
    }
    else{
      try {
        int warnzeit = int.parse(warnzeitTextController.text.trim());
        if(warnzeit<1){
          errorMessage+= "Die Warnzeit muss größer als 0 sein!\n";
        }
      } catch(e) {
        errorMessage+= "Die Warnzeit muss eine Zahl sein!\n";
      }
    }

    if(errorMessage.isNotEmpty){
      return false;
    }
    else{
      return true;
    }

  }


}

