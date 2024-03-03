

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:verwaltungsapp/dto/ArticleDTO.dart';
import '../dto/MengeDTO.dart';
import '../util/LiveApiRequest.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {

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
  bool loadedDataSuccessful = false;

  String errorMessage= "";

  @override
  void initState() {
    super.initState();
    print("Init State");

    loadData().whenComplete(() => setState(() {

      refresh();

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

    if (loadedData && loadedDataSuccessful) {

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

    }
    else if (loadedDataSuccessful == false && loadedData){

      return
      Scaffold(

        //resizeToAvoidBottomInset: false ,
          body: SafeArea(
              child:
          Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 20,),

              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Daten konnten nicht geladen werden!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 0,
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),

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
                          10)),
                  textStyle:
                  MaterialStateProperty
                      .all<TextStyle>(
                    const TextStyle(
                      fontSize: 18,
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

                    print("Neuladen!");
                    await loadData();
                    refresh();

                    setState(() {
                      loadedData = true;
                    });


                    }

                  },

                label: const Text("Erneut versuchen"),
                icon: const Icon(Icons.refresh),
              ),


            ],),
          ),
          )
      );

    }
    else {
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
                            await updateArticle(articleList2[selectedIndex!].artikel_id!);
                          }
                          else{
                            print("Fehler Eingabe!");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 3),
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
                      label: const Text("Speichern"),
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
                            editarticleView = false;
                            srollcontroller.jumpTo(0);
                            selectedIndex = null;
                          });

                        }

                      },
                      label: Text("Abbrechen"),
                      icon: const Icon(
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

                              fieldText.clear();

                              if(articleList2.length != articleListSearch.length){
                                print("Artikellisten sind ungleich");

                            refresh();

                              }
                              else{
                                print("Artikellisten sind gleich");
                              }

                              setState(() {
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
                              onPressed: (value) async {

                                if(loadedData){
                                  loadedData = false;

                                await  deleteArticle(articleListSearch[index].artikel_id!);

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
                              padding: EdgeInsets.all(5),
                              onPressed: (value) async {

                                if(loadedData){

                                  print("Artikel bearbeiten!");

                                  for( int i = 0 ; i <articleList2.length; i++ ) {
                                    if (articleList2[i].artikel_id == articleListSearch[index].artikel_id) {
                                      selectedIndex = i;
                                    }
                                  }

                                  image = articleList2[selectedIndex!].logo;
                                  nameTextController.text =articleList2[selectedIndex!].name ;
                                  sollmengeTextController.text = articleList2[selectedIndex!].sollmenge.toString();
                                  warnzeitTextController.text = articleList2[selectedIndex!].warnzeit.toString();

                                  setState(() {
                                    editarticleView=true;
                                  });


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
                              color:  articleListSearch[index].istmenge! < articleListSearch[index].sollmenge ? Colors.yellow[300] : Colors.white,
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
                                          articleListSearch[index].logo.isEmpty ?
                                          Image.asset("lib/images/articles/empty.png", fit: BoxFit.cover)
                                              :
                                          Image.memory(base64Decode(articleListSearch[index].logo), fit: BoxFit.cover,

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
                                                fontSize: 22,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),

                                              Text(
                                                "Soll: ${articleListSearch[index].sollmenge}     Ist: ${articleListSearch[index].istmenge ?? 0}",
                                                style: const TextStyle(
                                                  height: 0,
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),


                                            articleListSearch[index].istmenge! < articleListSearch[index].sollmenge ?

                                            Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text("Nachzukaufen: ${articleListSearch[index].sollmenge - articleListSearch[index].istmenge!}",
                                                style: const TextStyle(
                                                  height: 0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            )
                                            :
                                            Container(),

                                          ],
                                        ),
                                      ),

                                    ),

                               Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 5),
                                 child: Column(children: [

                                   articleListSearch[index].mengenListe!.isEmpty ?
                                   const Icon(
                                     Icons.star,
                                     color: Colors.black,
                                     size: 40,
                                   )
                                       : Container(),


                                   articleListSearch[index].mengenListe!.isNotEmpty && isOKMenge(articleListSearch[index]) ?
                                   const Icon(
                                     Icons.check,
                                     color: Colors.green,
                                     size: 40,
                                   )
                                       : Container(),

                                   articleListSearch[index].mengenListe!.isNotEmpty && isWarningMenge(articleListSearch[index]) ?
                                   const Icon(
                                     Icons.warning,
                                     color: Colors.orange,
                                     size: 40,
                                   )
                                       : Container(),

                                   articleListSearch[index].mengenListe!.isNotEmpty && isAbgelaufenMenge(articleListSearch[index]) ?
                                   const Icon(
                                     Icons.error,
                                     color: Colors.red,
                                     size: 40,
                                   )
                                       : Container(),

                                 ]),
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

  void refresh() {

    articleListSearch.clear();
    for (ArticleDTO a in articleList2) {
      if (a.name.toLowerCase().contains(fieldText.text.toLowerCase().trim())) {

        List<MengeDTO> mengenList = [];
        for (MengeDTO menge in a.mengenListe!) {
            mengenList.add(MengeDTO(mengen_id: menge.mengen_id, artikel_id: menge.artikel_id, datum: menge.datum, menge: menge.menge));
        }
        articleListSearch.add(ArticleDTO(artikel_id: a.artikel_id, logo: a.logo, name: a.name, sollmenge: a.sollmenge, istmenge: a.istmenge, warnzeit: a.warnzeit, mengenListe: mengenList));

      }
    }


  }



  void starteSuche(String value) {
    print("Artikelsuche gestartet! Value: $value");

    if (value.trim().isNotEmpty) {
      articleListSearch.clear();

      for (ArticleDTO a in articleList2) {
        if (a.name.toLowerCase().contains(value.toLowerCase().trim())) {
          print("Beschreibung ${a.name}");

          List<MengeDTO> mengenList = [];
          for (MengeDTO menge in a.mengenListe!) {
            mengenList.add(MengeDTO(mengen_id: menge.mengen_id, artikel_id: menge.artikel_id, datum: menge.datum, menge: menge.menge));
          }
          articleListSearch.add(ArticleDTO(artikel_id: a.artikel_id, logo: a.logo, name: a.name, sollmenge: a.sollmenge, istmenge: a.istmenge, warnzeit: a.warnzeit, mengenListe: mengenList));
        }
      }

      setState(() {
      });

    }
    else{

      if(articleList2.length != articleListSearch.length){
        print("Artikellisten sind ungleich");

        refresh();

        setState(() {
        });

      }
      else{
        print("Artikellisten sind gleich");
      }

    }

  }


  Future<void> loadData() async {

    articleList2.clear();

    await loadArticles();

    if(loadedDataSuccessful){

      for (ArticleDTO a in articleList2) {

        int ist=0;
        for (MengeDTO menge in a.mengenListe!) {
            ist+= menge.menge;
        }
        a.istmenge=ist;

      }

    }

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

      loadedDataSuccessful = true;
      for (int i = 0; i < articleList2.length; i++) {

        if(loadedDataSuccessful){
          await loadMengen(i);
        }
      }


    } else if (apiResponse.status == Status.EXCEPTION) {
      loadedDataSuccessful = false;
    } else if (apiResponse.status == Status.ERROR) {
      loadedDataSuccessful = false;
    }

  }

  loadMengen(int index) async{

    LiveApiRequest<MengeDTO> liveApiRequest =
    LiveApiRequest<MengeDTO>(url: "https://artikelapp.000webhostapp.com/getMengen.php");
    ApiResponse apiResponse = await liveApiRequest.executePost({"articleID": articleList2[index].artikel_id.toString()});
    if (apiResponse.status == Status.SUCCESS) {

      List<MengeDTO> mengenList = [];
      List<MengeDTO>.from(jsonDecode(apiResponse.body!)
          .map((model) => MengeDTO.fromJson(model))).forEach((element) {
        mengenList.add(element);
      });
      articleList2[index].mengenListe = mengenList;

      loadedDataSuccessful = true;

    } else if (apiResponse.status == Status.EXCEPTION) {
      loadedDataSuccessful = false;
    } else if (apiResponse.status == Status.ERROR) {
      loadedDataSuccessful = false;
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

      try {

        int article_id = int.parse(apiResponse.body!);

        articleList2.add(ArticleDTO(artikel_id: article_id, logo: image, name: nameTextController.text.trim(), sollmenge: int.parse(sollmengeTextController.text.trim()), istmenge: 0, warnzeit: int.parse(warnzeitTextController.text.trim()),mengenListe: []));

        refresh();

        setState(() {

          loadedData = true;

          image="";
          nameTextController.text="";
          sollmengeTextController.text="";
          warnzeitTextController.text="";

          addarticleView = false;
          srollcontroller.jumpTo(0);
        });

      } catch(e) {

        print("Unbekannter Fehler!");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 5),
          content:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
                child: Icon(color: Colors.blue, size: 40, Icons.info_outlined),
              ),
              Expanded(
                child:

                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("Ein Fehler ist aufgetreten!\nEs liegt warscheinlich an dem ausgewählten Artikelbild...\nVersuche es daher mit einem anderen Bild!",
                    softWrap: true,
                    style: TextStyle(
                      height: 0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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


  deleteArticle(int articleID) async{

    LiveApiRequest<ArticleDTO> liveApiRequest =
    LiveApiRequest<ArticleDTO>(url: "https://artikelapp.000webhostapp.com/deleteArticle.php");
    ApiResponse apiResponse = await liveApiRequest.executePost({
      "articleID": articleID.toString(),
    });
    if (apiResponse.status == Status.SUCCESS) {

      print("Artikel erfolgreich gelöscht!");

      int? index;
      for( int i = 0 ; i <articleList2.length; i++ ) {
        if (articleList2[i].artikel_id == articleID) {
          index = i;
        }
      }
      articleList2.removeAt(index!);


      refresh();

      setState(() {
        loadedData = true;
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


  updateArticle(int articleID) async{

    LiveApiRequest<ArticleDTO> liveApiRequest =
    LiveApiRequest<ArticleDTO>(url: "https://artikelapp.000webhostapp.com/updateArticle.php");
    ApiResponse apiResponse = await liveApiRequest.executePost({
      "articleID": articleID.toString(),
      "logo": image,
      "name": nameTextController.text.trim(),
      "sollmenge": sollmengeTextController.text.trim(),
      "warnzeit": warnzeitTextController.text.trim(),

    });
    if (apiResponse.status == Status.SUCCESS) {

      if(apiResponse.body?.compareTo("{\"Hat geklappt:\":true}") == 0){

        print("Artikel erfolgreich geupdadet!");

        articleList2[selectedIndex!].logo=image;
        articleList2[selectedIndex!].name=nameTextController.text.trim();
        articleList2[selectedIndex!].sollmenge= int.parse(sollmengeTextController.text.trim());
        articleList2[selectedIndex!].warnzeit= int.parse(warnzeitTextController.text.trim());

        refresh();

        setState(() {

          image="";
          nameTextController.text="";
          sollmengeTextController.text="";
          warnzeitTextController.text="";

          editarticleView = false;
          srollcontroller.jumpTo(0);
          selectedIndex = null;

          loadedData = true;
        });


      }
      else{

        print("Unbekannter Fehler!");
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
                child: Icon(color: Colors.blue, size: 40, Icons.info_outlined),
              ),
              Expanded(
                child:

                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("Ein Fehler ist aufgetreten!\nEs liegt warscheinlich an dem ausgewählten Artikelbild...\nVersuche es daher mit einem anderen Bild!",
                    softWrap: true,
                    style: TextStyle(
                      height: 0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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

        File?  imgcrop = await _cropImage(imageFile: File(image.path));
        if (imgcrop == null) return;

        setState(() {

          List<int> imageBytes = File(imgcrop.path).readAsBytesSync();
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

        File?  imgcrop = await _cropImage(imageFile: File(image.path));
        if (imgcrop == null) return;

        setState(() {

          List<int> imageBytes = File(imgcrop.path).readAsBytesSync();
          this.image = base64Encode(imageBytes);

        });

      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }

    }

  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
    await ImageCropper().cropImage(sourcePath: imageFile.path, cropStyle: CropStyle.circle, aspectRatioPresets:const [CropAspectRatioPreset.original]);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
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

   bool isOKMenge(ArticleDTO article) {

    for (MengeDTO m in article.mengenListe!) {

      DateTime now  =DateTime.now();
      DateTime datum = DateTime.parse(m.datum);

      DateTime nowFormated = DateTime(now.year, now.month, now.day);
      DateTime datumFormated = DateTime(datum.year, datum.month, datum.day);

      int difference = (datumFormated.difference(nowFormated).inHours / 24).round();
     // print("Difference: $difference Warnzeit: ${article.warnzeit}");

     if(article.warnzeit<= difference){
       return true;
     }

    }

      return false;

  }

  bool isWarningMenge(ArticleDTO article) {

    for (MengeDTO m in article.mengenListe!) {

      DateTime now  =DateTime.now();
      DateTime datum = DateTime.parse(m.datum);

      DateTime nowFormated = DateTime(now.year, now.month, now.day);
      DateTime datumFormated = DateTime(datum.year, datum.month, datum.day);

      int difference = (datumFormated.difference(nowFormated).inHours / 24).round();
     // print("Difference: $difference Warnzeit: ${article.warnzeit}");

      if(difference>=0 && article.warnzeit>= difference){
        return true;
      }

    }

    return false;

  }

  bool isAbgelaufenMenge(ArticleDTO article) {

    for (MengeDTO m in article.mengenListe!) {

      DateTime now  =DateTime.now();
      DateTime datum = DateTime.parse(m.datum);

      DateTime nowFormated = DateTime(now.year, now.month, now.day);
      DateTime datumFormated = DateTime(datum.year, datum.month, datum.day);

      int difference = (datumFormated.difference(nowFormated).inHours / 24).round();
     // print("Difference: $difference Warnzeit: ${article.warnzeit}");

      if(difference<0){
        return true;
      }

    }

    return false;

  }

}

