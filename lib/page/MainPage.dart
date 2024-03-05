import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
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

  List<ArticleDTO> articleList = [];
  List<ArticleDTO> articleListSearch = <ArticleDTO>[];

  ArticleDTO? selectedArticle;
  bool editarticleView = false;
  bool addarticleView = false;

  MengeDTO? selectedMenge;
  bool showMengenView = false;
  bool showEntnehmenView = false;

  final fieldText = TextEditingController();

  String image = "";
  final nameTextController = TextEditingController();
  final sollmengeTextController = TextEditingController();
  final warnzeitTextController = TextEditingController();

  final mengeTextController = TextEditingController();
  DateTime? datum;

  final entnehmenTextController = TextEditingController();

  bool loadedData = false;
  bool loadedDataSuccessful = false;

  String errorMessage = "";

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
  }

  @override
  Widget build(BuildContext context) {
    if (loadedData && loadedDataSuccessful) {
      return Scaffold(
          //resizeToAvoidBottomInset: false ,
          body: SafeArea(

              child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: getContent()
              ),

          ),
      );
    } else if (loadedDataSuccessful == false && loadedData) {
      return Scaffold(

          //resizeToAvoidBottomInset: false ,
          body: SafeArea(
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Daten konnten nicht geladen werden!",
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
                      MaterialStateProperty.all<Color>(Colors.grey),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors
                            .greenAccent; // Change this to desired press color
                      }
                      return Colors
                          .greenAccent; // Change this to desired press color
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                          color: Color(0xFF222222)), // Border color and width
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(10)),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Flutter doesn't support transitions for state changes; you'd use animations for that.
                ),
                onPressed: () async {
                  if (loadedData) {
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
            ],
          ),
        ),
      ));
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

  Widget getContent() {
    if (editarticleView) {
      return
      
        Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,

          child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Text(
                    "Artikel bearbeiten",
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
                
                Expanded(child: getAddArticleView()),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment:
                    // MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          overlayColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors
                                    .greenAccent; // Change this to desired press color
                              }
                              return Colors
                                  .greenAccent; // Change this to desired press color
                            },
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color:
                                      Color(0xFF222222)), // Border color and width
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(5)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Flutter doesn't support transitions for state changes; you'd use animations for that.
                        ),
                        onPressed: () async {
                          if (loadedData) {
                            loadedData = false;

                            if (checkUserInputArticle()) {
                              await updateArticle(selectedArticle!.artikel_id!);
                            } else {
                              print("Fehler Eingabe!");
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 3),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 15, top: 5, bottom: 5),
                                      child: Icon(
                                          color: Colors.orangeAccent,
                                          size: 40,
                                          Icons.warning_outlined),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          errorMessage,
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
                      const SizedBox(
                        width: 50,
                      ),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          overlayColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors
                                    .redAccent; // Change this to desired press color
                              }
                              return Colors
                                  .redAccent; // Change this to desired press color
                            },
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color:
                                      Color(0xFF222222)), // Border color and width
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(5)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Flutter doesn't support transitions for state changes; you'd use animations for that.
                        ),
                        onPressed: () {
                          if (loadedData) {
                            print("Abbrechen!");

                            image = "";
                            nameTextController.text = "";
                            sollmengeTextController.text = "";
                            warnzeitTextController.text = "";

                            setState(() {
                              editarticleView = false;
                              selectedArticle = null;
                            });
                          }
                        },
                        label: Text("Abbrechen"),
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
                ),
        );
    } else if (addarticleView) {
      return

        Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,

          child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 5),
                  child: Text(
                    "Artikel hinzufügen",
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
                Expanded(child: getAddArticleView()),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment:
                    // MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          overlayColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors
                                    .greenAccent; // Change this to desired press color
                              }
                              return Colors
                                  .greenAccent; // Change this to desired press color
                            },
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color:
                                      Color(0xFF222222)), // Border color and width
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(5)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Flutter doesn't support transitions for state changes; you'd use animations for that.
                        ),
                        onPressed: () async {
                          if (loadedData) {
                            loadedData = false;

                            if (checkUserInputArticle()) {
                              await addArticle();
                            } else {
                              print("Fehler Eingabe!");
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 3),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 15, top: 5, bottom: 5),
                                      child: Icon(
                                          color: Colors.orangeAccent,
                                          size: 40,
                                          Icons.warning_outlined),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          errorMessage,
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
                      const SizedBox(
                        width: 50,
                      ),
                      ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          overlayColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors
                                    .redAccent; // Change this to desired press color
                              }
                              return Colors
                                  .redAccent; // Change this to desired press color
                            },
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color:
                                      Color(0xFF222222)), // Border color and width
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(5)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Flutter doesn't support transitions for state changes; you'd use animations for that.
                        ),
                        onPressed: () {
                          if (loadedData) {
                            print("Abbrechen!");
                            image = "";
                            nameTextController.text = "";
                            sollmengeTextController.text = "";
                            warnzeitTextController.text = "";

                            setState(() {
                              addarticleView = false;
                            });
                          }
                        },
                        label: const Text("Abbrechen"),
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
                ),
        );
    } else if (showMengenView) {
      
      return Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Expanded(
                    flex: 4,
                    child:

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2), // Border width
                          decoration: const BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(50), // Image radius
                              child: selectedArticle!.logo.isEmpty
                                  ? Image.asset("lib/images/articles/empty.png",
                                      fit: BoxFit.cover)
                                  : Image.memory(
                                      base64Decode(selectedArticle!.logo),
                                      fit: BoxFit.cover,

                                      gaplessPlayback: true,
                                      // filterQuality: FilterQuality.high,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 6,
                    child:

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(selectedArticle!.name,
                        softWrap: true,
                        //maxLines: 1,
                        style: const TextStyle(
                          height: 0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            
            Expanded(
              child:
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: selectedArticle!.mengenListe!.isEmpty ?

                  Container(
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
                :
                SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  child: ListView.builder(
                      //  shrinkWrap: true,
                      // physics: const ScrollPhysics(),
                      itemCount: selectedArticle!.mengenListe!.length,
                      itemBuilder: (context, index) {
                        return Slidable(
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

                                   await deleteMenge(selectedArticle!.mengenListe![index]);

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

                              if(loadedData){

                                 print("Ausgewählte Menge: Anzahl: ${selectedArticle!.mengenListe![index].menge} Datum: ${selectedArticle!.mengenListe![index].datum}");

                                 entnehmenTextController.text = "0";
                                 selectedMenge = selectedArticle!.mengenListe![index];

                                setState(() {
                                  showEntnehmenView = true;
                                  showMengenView = false;
                                });

                              }


                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                margin: const EdgeInsets.all(5),
                                color: Colors.white,
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [

                                      Container(
                                        child:

                                        Column(children: [

                                          const Text(
                                          "Anzahl",
                                            style: TextStyle(
                                              height: 0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),

                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            margin: EdgeInsets.symmetric(vertical: 3),
                                            color: Colors.grey,
                                            elevation: 3,
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                              child: Text(
                                                selectedArticle!
                                                    .mengenListe![index]
                                                    .menge
                                                    .toString(),
                                                style: const TextStyle(
                                                  height: 0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],),
                                      ),

                                      const SizedBox(
                                        width: 10,
                                      ),


                                      Expanded(
                                        child: Container(

                                          child:

                                          Column(children: [

                                            const Text(
                                              "Mindesthaltbarkeitsdatum",
                                              style: TextStyle(
                                                height: 0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 16,
                                              ),
                                            ),

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
                                                  child:  Text(
                                                    DateFormat('dd.MM.yyyy').format(DateTime.parse(selectedArticle!.mengenListe![index].datum)),
                                                    style: const TextStyle(
                                                      height: 0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                             getDifferenceDates(selectedArticle!.mengenListe![index].datum) > selectedArticle!.warnzeit
                                                    ? const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 40,
                                                )
                                                    : Container(),

                                                getDifferenceDates(selectedArticle!.mengenListe![index].datum) <= selectedArticle!.warnzeit  &&  getDifferenceDates(selectedArticle!.mengenListe![index].datum) >= 0
                                                    ? const Icon(
                                                  Icons.warning,
                                                  color: Colors.orange,
                                                  size: 40,
                                                )
                                                    : Container(),

                                                getDifferenceDates(selectedArticle!.mengenListe![index].datum) < 0
                                                    ? const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                  size: 40,
                                                )
                                                    : Container(),

                                            ],),

                                          ],),

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
            ),

            Container(
              decoration: BoxDecoration(
                  color:  Colors.grey[200],
              ),
              padding: const EdgeInsets.only(top: 15,bottom: 20),
              child:

              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Column(children: [

                    const Text(
                      "Anzahl",
                      style: TextStyle(
                        height: 0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                    Row(children: [

                      GestureDetector(
                        onTap: () {

                          if(loadedData){

                            try {

                              int menge = int.parse(mengeTextController.text);

                              if(menge<0){
                                mengeTextController.text = "0";
                              }
                              else if(menge == 0){
                              }
                              else{

                                menge--;
                                mengeTextController.text = menge.toString();

                              }

                            } catch(e) {
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
                        child:

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: 40,
                          child: TextField(
                            controller: mengeTextController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                            textAlignVertical: TextAlignVertical.center,
                            maxLength: 25,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(),
                              filled: true,
                              fillColor: Colors.white,
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

                      ),

                      GestureDetector(
                        onTap: () {

                          if(loadedData){

                            try {

                              int menge = int.parse(mengeTextController.text);

                              if(menge<0){
                                mengeTextController.text = "0";
                              }
                              else{

                                menge++;
                                mengeTextController.text = menge.toString();

                              }

                            } catch(e) {
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

                    ],),




                  ],),


                  Container(

                    child:

                    Column(children: [

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

                          if(loadedData){

                            DateTime? pickedDate= await showDatePicker(context: context, locale: const Locale("de","DE"), firstDate: DateTime(2000), lastDate: DateTime(2050),initialDate: DateTime.now());

                            if(pickedDate != null){
                              datum = pickedDate;
                            }

                            setState(() {});

                          }

                        },
                        style:
                        ElevatedButton.styleFrom(
                          foregroundColor:
                          Colors.black,
                          backgroundColor:
                          Colors.blue,
                          side: const BorderSide(
                              color: Colors.black,
                              width: 1),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(0),
                          ),
                          // Text Color (Foreground color)
                        ),
                        child:
                        datum != null ?
                        Text(
                          DateFormat('dd.MM.yyyy').format(datum!),
                          style: const TextStyle(fontSize: 18,),
                        )
                        :
                        const Text(
                          'Datum auswählen',
                          style: TextStyle(fontSize: 18,),
                        ),

                      )

                    ],),

                  ),

                ],
              ),


            ),


       Padding(
         padding: const EdgeInsets.all(10.0),
         child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,
                children: [

                  ElevatedButton(
                    onPressed: () {

                      if(loadedData){

                        print("Zurück!");
                        setState(() {

                          selectedArticle = null;
                          showMengenView = false;
                          mengeTextController.text = "0";
                          datum = null;
                          refresh();
                        });

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


                  // SizedBox(width: MediaQuery.of(context).size.width* 0.05),

                  ElevatedButton(
                    onPressed: () async {

                      if(loadedData){
                        loadedData = false;
                        print("Hinzufügen");

                        if(checkUserInputMenge()){

                          MengeDTO? menge;

                          for (MengeDTO m in  selectedArticle!.mengenListe!) {

                            DateTime mengendatum = DateTime.parse(m.datum);
                            DateTime datumFormated = DateTime(datum!.year, datum!.month, datum!.day);


                            int difference = (mengendatum.difference(datumFormated).inHours / 24).round();

                            if(difference == 0 ){
                              menge = m;
                            }

                          }

                          if(menge == null){

                           await addMenge();
                          }
                          else{

                          await updateMenge(menge, menge.menge + int.parse(mengeTextController.text.trim()));

                          }

                        }
                        else{

                          print("Fehler Eingabe!");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 3),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 5, right: 15, top: 5, bottom: 5),
                                  child: Icon(
                                      color: Colors.orangeAccent,
                                      size: 40,
                                      Icons.warning_outlined),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      errorMessage,
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
                      'Hinzufügen',
                      style: TextStyle(fontSize: 18,),
                    ),
                  )
                ],
              ),
       ),



          ],
        ),
      );
    }
    else if (showEntnehmenView) {

      return Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
        child: Column(
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
                        child: selectedArticle!.logo.isEmpty
                            ? Image.asset("lib/images/articles/empty.png",
                            fit: BoxFit.cover)
                            : Image.memory(
                          base64Decode(selectedArticle!.logo),
                          fit: BoxFit.cover,

                          gaplessPlayback: true,
                          // filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only( top: 10),
                    child: Text(selectedArticle!.name,
                      softWrap: true,
                      maxLines: 2,
                      style: const TextStyle(
                        height: 0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
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

                              Container(
                                child:

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
                                      child: Text(selectedMenge!.menge.toString(),
                                        style: const TextStyle(
                                          height: 0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],),
                              ),

                              const SizedBox(
                                width: 10,
                              ),


                              Expanded(
                                child: Container(

                                  child:

                                  Column(children: [

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
                                            child:  Text(
                                              DateFormat('dd.MM.yyyy').format(DateTime.parse(selectedMenge!.datum)),
                                              style: const TextStyle(
                                                height: 0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ),

                                        getDifferenceDates(selectedMenge!.datum) > selectedArticle!.warnzeit
                                            ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 50,
                                        )
                                            : Container(),

                                        getDifferenceDates(selectedMenge!.datum) <= selectedArticle!.warnzeit  &&  getDifferenceDates(selectedMenge!.datum) >= 0
                                            ? const Icon(
                                          Icons.warning,
                                          color: Colors.orange,
                                          size: 50,
                                        )
                                            : Container(),

                                        getDifferenceDates(selectedMenge!.datum) < 0
                                            ? const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        )
                                            : Container(),

                                      ],),

                                  ],),

                                ),
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

                                    int menge = int.parse(entnehmenTextController.text);

                                    if(menge<0 || menge > selectedMenge!.menge){
                                      entnehmenTextController.text = "0";
                                    }
                                    else if(menge == 0){
                                    }
                                    else{

                                      menge--;
                                      entnehmenTextController.text = menge.toString();

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

                                    int menge = int.parse(entnehmenTextController.text);

                                    if(menge<0 || menge > selectedMenge!.menge){
                                      entnehmenTextController.text = "0";
                                    }
                                    else if(menge == selectedMenge!.menge){
                                    }
                                    else{

                                      menge++;
                                      entnehmenTextController.text = menge.toString();

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
                          loadedData = false;

                          if(checkUserInputEntnehmen()){

                              if(selectedMenge!.menge == int.parse(entnehmenTextController.text)){
                                  await deleteMenge(selectedMenge!);
                              }
                              else{
                                  await entnehmeMenge(selectedMenge!, selectedMenge!.menge - int.parse(entnehmenTextController.text.trim()));
                              }

                          }
                          else{

                            print("Fehler Eingabe!");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 3),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, right: 15, top: 5, bottom: 5),
                                    child: Icon(
                                        color: Colors.orangeAccent,
                                        size: 40,
                                        Icons.warning_outlined),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        errorMessage,
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
                          setState(() {

                            selectedMenge = null;
                            entnehmenTextController.text = "0";

                            showEntnehmenView = false;
                            showMengenView = true;

                          });

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


                  // SizedBox(width: MediaQuery.of(context).size.width* 0.05),


                ],
              ),
            ),

          ],
        ),
      );

    }
    else {

      return Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 50
                      : 40,
                  width: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? MediaQuery.of(context).size.width * 0.7
                      : MediaQuery.of(context).size.width * 0.6,
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
                        starteSuche(value);
                      }
                    },
                    onSubmitted: (value) {
                      if (loadedData) {
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
                          if (loadedData) {
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
                            if (loadedData) {
                              print("Suchfeld gecleart!");

                              fieldText.clear();

                              if (articleList.length !=
                                  articleListSearch.length) {
                                print("Artikellisten sind ungleich");

                                refresh();
                              } else {
                                print("Artikellisten sind gleich");
                              }

                              setState(() {});
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

                          setState(() {
                            addarticleView = true;
                          });
                        }
                      },
                      child: const Icon(
                        Icons.add_circle_outline_outlined,
                        size: 40,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),



            Expanded(
              child: articleList.isEmpty || articleListSearch.isEmpty
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
                          //  shrinkWrap: true,
                          // physics: const ScrollPhysics(),
                          itemCount: articleListSearch.length,
                          itemBuilder: (context, index) {
                            return Slidable(
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

                                        loadedData = false;
                                        await deleteArticle(articleListSearch[index]);

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
                                    onPressed: (value) async {
                                      if (loadedData) {
                                        print("Artikel bearbeiten!");

                                        ArticleDTO article = articleListSearch[index];

                                        image =article.logo;
                                        nameTextController.text = article.name;
                                        sollmengeTextController.text = article.sollmenge.toString();
                                        warnzeitTextController.text = article.warnzeit.toString();

                                        selectedArticle = article;

                                        setState(() {
                                          editarticleView = true;
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

                                  if(loadedData){

                                    print("Ausgewählter Artikel: ${articleListSearch[index].name}");

                                    ArticleDTO article = articleListSearch[index];

                                    article.mengenListe!.sort((a, b) => getDifferenceDates(a.datum).compareTo(getDifferenceDates(b.datum)));
                                    mengeTextController.text = "0";
                                    datum = null;

                                    selectedArticle = article;

                                    setState(() {
                                      showMengenView = true;
                                    });

                                  }

                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    margin: const EdgeInsets.all(5),
                                    color: articleListSearch[index].istmenge! <
                                            articleListSearch[index].sollmenge
                                        ? Colors.yellow[300]
                                        : Colors.white,
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                                2), // Border width
                                            decoration: const BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle),
                                            child: ClipOval(
                                              child: SizedBox.fromSize(
                                                size: const Size.fromRadius(
                                                    35), // Image radius
                                                child: articleListSearch[index]
                                                        .logo
                                                        .isEmpty
                                                    ? Image.asset(
                                                        "lib/images/articles/empty.png",
                                                        fit: BoxFit.cover)
                                                    : Image.memory(
                                                        base64Decode(
                                                            articleListSearch[
                                                                    index]
                                                                .logo),
                                                        fit: BoxFit.cover,

                                                        gaplessPlayback: true,
                                                        // filterQuality: FilterQuality.high,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
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
                                                    articleListSearch[index]
                                                        .name,
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
                                                    "Soll: ${articleListSearch[index].sollmenge}     Ist: ${articleListSearch[index].istmenge ?? 0}",
                                                    style: const TextStyle(
                                                      height: 0,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  articleListSearch[index]
                                                              .istmenge! <
                                                          articleListSearch[
                                                                  index]
                                                              .sollmenge
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          child: Text(
                                                            "Nachzukaufen: ${articleListSearch[index].sollmenge - articleListSearch[index].istmenge!}",
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
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Column(children: [
                                              articleListSearch[index]
                                                      .mengenListe!
                                                      .isEmpty
                                                  ? const Icon(
                                                      Icons.star,
                                                      color: Colors.black,
                                                      size: 40,
                                                    )
                                                  : Container(),
                                              articleListSearch[index]
                                                          .mengenListe!
                                                          .isNotEmpty &&
                                                      isOKMenge(
                                                          articleListSearch[
                                                              index])
                                                  ? const Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                      size: 40,
                                                    )
                                                  : Container(),
                                              articleListSearch[index]
                                                          .mengenListe!
                                                          .isNotEmpty &&
                                                      isWarningMenge(
                                                          articleListSearch[
                                                              index])
                                                  ? const Icon(
                                                      Icons.warning,
                                                      color: Colors.orange,
                                                      size: 40,
                                                    )
                                                  : Container(),
                                              articleListSearch[index]
                                                          .mengenListe!
                                                          .isNotEmpty &&
                                                      isAbgelaufenMenge(
                                                          articleListSearch[
                                                              index])
                                                  ? const Icon(
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
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      );
    }
  }



  Widget getAddArticleView() {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3),
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(100), // Image radius
                    child: image.isNotEmpty
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
                    padding: const EdgeInsets.only(top: 10, right: 20),
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
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  "Artikelname" + ":",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.48,
              height: 30,
              child: TextField(
                controller: nameTextController,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
                textAlignVertical: TextAlignVertical.center,
                maxLength: 25,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(),
                  filled: true,
                  fillColor: Colors.grey[100],
                  counterText: "",
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  hintText: "Artikelname" + "...",
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
              width: MediaQuery.of(context).size.width * 0.35,
              child: const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  "Sollmenge" + ":",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.48,
              height: 30,
              child: TextField(
                controller: sollmengeTextController,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
                textAlignVertical: TextAlignVertical.center,
                maxLength: 25,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(),
                  filled: true,
                  fillColor: Colors.grey[100],
                  counterText: "",
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  hintText: "Sollmenge" + "...",
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
              width: MediaQuery.of(context).size.width * 0.35,
              child: const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  "Warnzeit in Tagen" + ":",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.48,
              height: 30,
              child: TextField(
                controller: warnzeitTextController,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
                textAlignVertical: TextAlignVertical.center,
                // maxLength: 25,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(),
                  filled: true,
                  fillColor: Colors.grey[100],
                  counterText: "",
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide:
                        BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  hintText: "Warnzeit in Tagen" + "...",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void refresh() {
    articleListSearch.clear();
    for (ArticleDTO a in articleList) {
      if (a.name.toLowerCase().contains(fieldText.text.toLowerCase().trim())) {

        articleListSearch.add(a);

      }
    }
  }

  void starteSuche(String value) {
    print("Artikelsuche gestartet! Value: $value");

    if (value.trim().isNotEmpty) {
      articleListSearch.clear();

      for (ArticleDTO a in articleList) {
        if (a.name.toLowerCase().contains(value.toLowerCase().trim())) {
          print("Beschreibung ${a.name}");

          articleListSearch.add(a);

        }
      }

      setState(() {});
    } else {
      if (articleList.length != articleListSearch.length) {
        print("Artikellisten sind ungleich");

        refresh();

        setState(() {});
      } else {
        print("Artikellisten sind gleich");
      }
    }
  }

  Future<void> loadData() async {
    articleList.clear();

    await loadArticles();

    if (loadedDataSuccessful) {
      for (ArticleDTO a in articleList) {
        int ist = 0;
        for (MengeDTO menge in a.mengenListe!) {
          ist += menge.menge;
        }
        a.istmenge = ist;
      }
    }
  }

  loadArticles() async {
    LiveApiRequest<ArticleDTO> liveApiRequest = LiveApiRequest<ArticleDTO>(
        url: "https://artikelapp.000webhostapp.com/getArticle.php");
    ApiResponse apiResponse = await liveApiRequest.executeGet();
    if (apiResponse.status == Status.SUCCESS) {
      print("Artikel erfolgreich geladen!");

      List<ArticleDTO>.from(jsonDecode(apiResponse.body!)
          .map((model) => ArticleDTO.fromJson(model))).forEach((element) {
        articleList.add(element);
      });

      loadedDataSuccessful = true;
      for (int i = 0; i < articleList.length; i++) {
        if (loadedDataSuccessful) {
          await loadMengen(i);
        }
      }
    } else if (apiResponse.status == Status.EXCEPTION) {
      loadedDataSuccessful = false;
    } else if (apiResponse.status == Status.ERROR) {
      loadedDataSuccessful = false;
    }
  }

  loadMengen(int index) async {
    LiveApiRequest<MengeDTO> liveApiRequest = LiveApiRequest<MengeDTO>(
        url: "https://artikelapp.000webhostapp.com/getMengen.php");
    ApiResponse apiResponse = await liveApiRequest
        .executePost({"articleID": articleList[index].artikel_id.toString()});
    if (apiResponse.status == Status.SUCCESS) {
      List<MengeDTO> mengenList = [];
      List<MengeDTO>.from(jsonDecode(apiResponse.body!)
          .map((model) => MengeDTO.fromJson(model))).forEach((element) {
        mengenList.add(element);
      });
      articleList[index].mengenListe = mengenList;

      loadedDataSuccessful = true;
    } else if (apiResponse.status == Status.EXCEPTION) {
      loadedDataSuccessful = false;
    } else if (apiResponse.status == Status.ERROR) {
      loadedDataSuccessful = false;
    }
  }

  addArticle() async {
    LiveApiRequest<ArticleDTO> liveApiRequest = LiveApiRequest<ArticleDTO>(
        url: "https://artikelapp.000webhostapp.com/addArticle.php");
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

        articleList.add(ArticleDTO(
            artikel_id: article_id,
            logo: image,
            name: nameTextController.text.trim(),
            sollmenge: int.parse(sollmengeTextController.text.trim()),
            istmenge: 0,
            warnzeit: int.parse(warnzeitTextController.text.trim()),
            mengenListe: []));

        refresh();

        setState(() {
          loadedData = true;

          image = "";
          nameTextController.text = "";
          sollmengeTextController.text = "";
          warnzeitTextController.text = "";

          addarticleView = false;
        });
      } catch (e) {
        print("Unbekannter Fehler!");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 5),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
                child: Icon(color: Colors.blue, size: 40, Icons.info_outlined),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Ein Fehler ist aufgetreten!\nEs liegt warscheinlich an dem ausgewählten Artikelbild...\nVersuche es daher mit einem anderen Bild!",
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
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child:
                  Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Server nicht erreichbar...\nPrüfe deine Internetverbindung!",
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
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child: Icon(color: Colors.red, size: 40, Icons.error_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Es ist ein Serverfehler aufgetreten!",
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

  deleteArticle(ArticleDTO article) async {
    LiveApiRequest<ArticleDTO> liveApiRequest = LiveApiRequest<ArticleDTO>(
        url: "https://artikelapp.000webhostapp.com/deleteArticle.php");
    ApiResponse apiResponse = await liveApiRequest.executePost({
      "articleID": article.artikel_id.toString(),
    });
    if (apiResponse.status == Status.SUCCESS) {
      print("Artikel erfolgreich gelöscht!");

      articleList.remove(article);
      refresh();

      setState(() {
        loadedData = true;
      });

    } else if (apiResponse.status == Status.EXCEPTION) {
      print("Exception!");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child:
                  Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Server nicht erreichbar...\nPrüfe deine Internetverbindung!",
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
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child: Icon(color: Colors.red, size: 40, Icons.error_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Es ist ein Serverfehler aufgetreten!",
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

  updateArticle(int articleID) async {
    LiveApiRequest<ArticleDTO> liveApiRequest = LiveApiRequest<ArticleDTO>(
        url: "https://artikelapp.000webhostapp.com/updateArticle.php");
    ApiResponse apiResponse = await liveApiRequest.executePost({
      "articleID": articleID.toString(),
      "logo": image,
      "name": nameTextController.text.trim(),
      "sollmenge": sollmengeTextController.text.trim(),
      "warnzeit": warnzeitTextController.text.trim(),
    });
    if (apiResponse.status == Status.SUCCESS) {
      if (apiResponse.body?.compareTo("{\"Hat geklappt:\":true}") == 0) {
        print("Artikel erfolgreich geupdadet!");

        selectedArticle!.logo = image;
        selectedArticle!.name = nameTextController.text.trim();
        selectedArticle!.sollmenge = int.parse(sollmengeTextController.text.trim());
        selectedArticle!.warnzeit = int.parse(warnzeitTextController.text.trim());

        refresh();

        setState(() {
          image = "";
          nameTextController.text = "";
          sollmengeTextController.text = "";
          warnzeitTextController.text = "";

          editarticleView = false;
          selectedArticle = null;

          loadedData = true;
        });
      } else {
        print("Unbekannter Fehler!");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
                child: Icon(color: Colors.blue, size: 40, Icons.info_outlined),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Ein Fehler ist aufgetreten!\nEs liegt warscheinlich an dem ausgewählten Artikelbild...\nVersuche es daher mit einem anderen Bild!",
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
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child:
                  Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Server nicht erreichbar...\nPrüfe deine Internetverbindung!",
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
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child: Icon(color: Colors.red, size: 40, Icons.error_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Es ist ein Serverfehler aufgetreten!",
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

  updateMenge(MengeDTO mDTO, int menge) async {

    LiveApiRequest<MengeDTO> liveApiRequest = LiveApiRequest<MengeDTO>(
        url: "https://artikelapp.000webhostapp.com/updateMenge.php");
    ApiResponse apiResponse = await liveApiRequest.executePost({
      "mengenID": mDTO.mengen_id.toString(),
      "menge": menge.toString(),
    });
    if (apiResponse.status == Status.SUCCESS) {

        print("Menge erfolgreich geupdadet!");

        mDTO.menge = menge ;

        int ist = 0;
        for (MengeDTO m in selectedArticle!.mengenListe!) {
            ist += m.menge;
        }
        selectedArticle!.istmenge = ist;


        setState(() {

          mengeTextController.text = "0";
          datum = null;
          selectedArticle!.mengenListe!.sort((a, b) => getDifferenceDates(a.datum).compareTo(getDifferenceDates(b.datum)));

          loadedData = true;
        });


    } else if (apiResponse.status == Status.EXCEPTION) {
      print("Exception!");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child:
              Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Server nicht erreichbar...\nPrüfe deine Internetverbindung!",
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
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child: Icon(color: Colors.red, size: 40, Icons.error_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Es ist ein Serverfehler aufgetreten!",
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

  addMenge() async {

    LiveApiRequest<MengeDTO> liveApiRequest = LiveApiRequest<MengeDTO>(
        url: "https://artikelapp.000webhostapp.com/addMenge.php");
    ApiResponse apiResponse = await liveApiRequest.executePost({
      "artikelID": selectedArticle!.artikel_id.toString(),
      "menge": mengeTextController.text.trim(),
      "datum": DateFormat('yyyy-MM-dd').format(datum!),
    });
    if (apiResponse.status == Status.SUCCESS) {

      print("Menge erfolgreich hinzugefügt!");

      int mengen_id = int.parse(apiResponse.body!);

      selectedArticle!.mengenListe!.add(MengeDTO(mengen_id: mengen_id, artikel_id: selectedArticle!.artikel_id! , datum: datum.toString(), menge: int.parse(mengeTextController.text.trim())));

      int ist = 0;
      for (MengeDTO m in selectedArticle!.mengenListe!) {
        ist += m.menge;
      }
      selectedArticle!.istmenge = ist;


      setState(() {

        mengeTextController.text = "0";
        datum = null;
        selectedArticle!.mengenListe!.sort((a, b) => getDifferenceDates(a.datum).compareTo(getDifferenceDates(b.datum)));

        loadedData = true;
      });


    } else if (apiResponse.status == Status.EXCEPTION) {
      print("Exception!");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child:
              Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Server nicht erreichbar...\nPrüfe deine Internetverbindung!",
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
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child: Icon(color: Colors.red, size: 40, Icons.error_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Es ist ein Serverfehler aufgetreten!",
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

  deleteMenge(MengeDTO mengeDTO) async {

      LiveApiRequest<MengeDTO> liveApiRequest = LiveApiRequest<MengeDTO>(
          url: "https://artikelapp.000webhostapp.com/deleteMenge.php");
      ApiResponse apiResponse = await liveApiRequest.executePost({
        "mengenID": mengeDTO.mengen_id.toString(),
      });
      if (apiResponse.status == Status.SUCCESS) {

        print("Menge erfolgreich gelöscht!");

        selectedArticle!.mengenListe!.remove(mengeDTO);

        int ist = 0;
        for (MengeDTO m in selectedArticle!.mengenListe!) {
          ist += m.menge;
        }
        selectedArticle!.istmenge = ist;

        setState(() {

          showEntnehmenView = false;
          showMengenView = true;

          selectedMenge = null;
          entnehmenTextController.text = "0";

          loadedData = true;
        });

      } else if (apiResponse.status == Status.EXCEPTION) {
        print("Exception!");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 3),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
                child:
                Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Server nicht erreichbar...\nPrüfe deine Internetverbindung!",
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
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
                child: Icon(color: Colors.red, size: 40, Icons.error_outlined),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Es ist ein Serverfehler aufgetreten!",
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

  entnehmeMenge(MengeDTO mDTO, int menge) async {

    LiveApiRequest<MengeDTO> liveApiRequest = LiveApiRequest<MengeDTO>(
        url: "https://artikelapp.000webhostapp.com/updateMenge.php");
    ApiResponse apiResponse = await liveApiRequest.executePost({
      "mengenID": mDTO.mengen_id.toString(),
      "menge": menge.toString(),
    });
    if (apiResponse.status == Status.SUCCESS) {

      print("Menge erfolgreich entnommen!");

      mDTO.menge = menge ;

      int ist = 0;
      for (MengeDTO m in selectedArticle!.mengenListe!) {
        ist += m.menge;
      }
      selectedArticle!.istmenge = ist;


      setState(() {

        entnehmenTextController.text = "0";
        loadedData = true;
      });


    } else if (apiResponse.status == Status.EXCEPTION) {
      print("Exception!");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child:
              Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Server nicht erreichbar...\nPrüfe deine Internetverbindung!",
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
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child: Icon(color: Colors.red, size: 40, Icons.error_outlined),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Es ist ein Serverfehler aufgetreten!",
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
    if (loadedData) {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (image == null) return;

        File? imgcrop = await _cropImage(imageFile: File(image.path));
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
    if (loadedData) {
      try {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);

        if (image == null) return;

        File? imgcrop = await _cropImage(imageFile: File(image.path));
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
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: const [CropAspectRatioPreset.original]);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  bool checkUserInputArticle() {
    errorMessage = "";

    if (nameTextController.text.trim().isEmpty) {
      errorMessage += "Gebe einen Artikelnamen ein!\n";
    }

    if (sollmengeTextController.text.trim().isEmpty) {
      errorMessage += "Gebe die Sollmenge ein!\n";
    } else {
      try {
        int sollmenge = int.parse(sollmengeTextController.text.trim());
        if (sollmenge < 0) {
          errorMessage += "Die Sollmenge darf nicht negativ sein!\n";
        }
      } catch (e) {
        errorMessage += "Die Sollmenge muss eine Zahl sein!\n";
      }
    }

    if (warnzeitTextController.text.trim().isEmpty) {
      errorMessage += "Gebe die Warnzeit ein!\n";
    } else {
      try {
        int warnzeit = int.parse(warnzeitTextController.text.trim());
        if (warnzeit < 1) {
          errorMessage += "Die Warnzeit muss größer als 0 sein!\n";
        }
      } catch (e) {
        errorMessage += "Die Warnzeit muss eine Zahl sein!\n";
      }
    }

    if (errorMessage.isNotEmpty) {
      return false;
    } else {
      return true;
    }
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

  bool checkUserInputEntnehmen() {

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
        if (menge > selectedMenge!.menge) {
          errorMessage += "Du kannst höchstens ${selectedMenge!.menge} Artikel entnehmen!\n";
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

  bool isOKMenge(ArticleDTO article) {
    for (MengeDTO m in article.mengenListe!) {
      DateTime now = DateTime.now();
      DateTime datum = DateTime.parse(m.datum);

      DateTime nowFormated = DateTime(now.year, now.month, now.day);
      DateTime datumFormated = DateTime(datum.year, datum.month, datum.day);

      int difference =
          (datumFormated.difference(nowFormated).inHours / 24).round();
      // print("Difference: $difference Warnzeit: ${article.warnzeit}");

      if (article.warnzeit <= difference) {
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

  int getDifferenceDates(String date) {

      DateTime now = DateTime.now();
      DateTime datum = DateTime.parse(date);

      DateTime nowFormated = DateTime(now.year, now.month, now.day);
      DateTime datumFormated = DateTime(datum.year, datum.month, datum.day);

      int difference =
      (datumFormated.difference(nowFormated).inHours / 24).round();
      // print("Difference: $difference Warnzeit: ${article.warnzeit}");

    return difference;

  }

}
