import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:verwaltungsapp/dto/ArticleDTO.dart';
import 'package:verwaltungsapp/page/EntnehmenPage.dart';
import 'package:verwaltungsapp/util/HelperUtil.dart';
import '../dto/MengeDTO.dart';
import '../util/LiveApiRequest.dart';

class MengenPage extends StatefulWidget {
  final ArticleDTO selectedArticle;
  const MengenPage({Key? key,  required this.selectedArticle}) : super(key: key);

  @override
  State<MengenPage> createState() => _MengenPageState();
}

class _MengenPageState extends State<MengenPage> {

  bool loadedData = true;

  final mengeTextController = TextEditingController();
  DateTime? datum;

  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    print("Init State Mengen-Page");

    mengeTextController.text = "0";

  }

  @override
  dispose() {
    print("Disposed Mengen-Page");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                                padding: const EdgeInsets.all(2), // Border width
                                decoration: const BoxDecoration(
                                    color: Colors.black, shape: BoxShape.circle),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(50), // Image radius
                                    child: widget.selectedArticle.logo.isEmpty
                                        ? Image.asset("lib/images/articles/empty.png",
                                        fit: BoxFit.cover)
                                        : Image.memory(
                                      base64Decode(widget.selectedArticle.logo),
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
                            child: Text(widget.selectedArticle.name,
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
                      child: widget.selectedArticle.mengenListe!.isEmpty ?

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
                            itemCount: widget.selectedArticle.mengenListe!.length,
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

                                          setState(() {
                                            loadedData = false;
                                          });

                                          await deleteMenge(widget.selectedArticle.mengenListe![index]);

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

                                    if(loadedData){

                                      print("Ausgewählte Menge: Anzahl: ${widget.selectedArticle.mengenListe![index].menge} Datum: ${widget.selectedArticle.mengenListe![index].datum}");

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EntnehmenPage(selectedArticle: widget.selectedArticle, selectedMenge: widget.selectedArticle.mengenListe![index]),
                                        ),
                                      ).then((value) => setState(() {}));

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
                                                  margin: const EdgeInsets.symmetric(vertical: 3),
                                                  color: Colors.grey,
                                                  elevation: 3,
                                                  child:
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                    child: Text(
                                                      widget.selectedArticle
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
                                                           HelperUtil.formatDateTime(DateTime.parse(widget.selectedArticle.mengenListe![index].datum)) ,
                                                            style: const TextStyle(
                                                              height: 0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      HelperUtil.getDifferenceDates(widget.selectedArticle.mengenListe![index].datum) > widget.selectedArticle.warnzeit
                                                          ? const Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                        size: 40,
                                                      )
                                                          : Container(),

                                                      HelperUtil.getDifferenceDates(widget.selectedArticle.mengenListe![index].datum) <= widget.selectedArticle.warnzeit  &&   HelperUtil.getDifferenceDates(widget.selectedArticle.mengenListe![index].datum) >= 0
                                                          ? const Icon(
                                                        Icons.warning,
                                                        color: Colors.orange,
                                                        size: 40,
                                                      )
                                                          : Container(),

                                                      HelperUtil.getDifferenceDates(widget.selectedArticle.mengenListe![index].datum) < 0
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

                                mengeTextController.text = "0";
                                datum = null;

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


                        // SizedBox(width: MediaQuery.of(context).size.width* 0.05),

                        ElevatedButton(
                          onPressed: () async {

                            if(loadedData){
                              setState(() {
                                loadedData = false;
                              });

                              print("Hinzufügen");

                              if(checkUserInputMenge()){

                                MengeDTO? menge;

                                for (MengeDTO m in widget.selectedArticle.mengenListe!) {

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
                            'Hinzufügen',
                            style: TextStyle(fontSize: 18,),
                          ),
                        )
                      ],
                    ),
                  ),



                ],
              ),
            ),

          ),
        ),
      );

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
      for (MengeDTO m in widget.selectedArticle.mengenListe!) {
        ist += m.menge;
      }
      widget.selectedArticle.istmenge = ist;


      setState(() {

        mengeTextController.text = "0";
        datum = null;
        widget.selectedArticle.mengenListe!.sort((a, b) =>  HelperUtil.getDifferenceDates(a.datum).compareTo( HelperUtil.getDifferenceDates(b.datum)));

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
    }

  }

  addMenge() async {

    LiveApiRequest<MengeDTO> liveApiRequest = LiveApiRequest<MengeDTO>(
        url: "https://artikelapp.000webhostapp.com/addMenge.php");
    ApiResponse apiResponse = await liveApiRequest.executePost({
      "artikelID": widget.selectedArticle.artikel_id.toString(),
      "menge": mengeTextController.text.trim(),
      "datum": DateFormat('yyyy-MM-dd').format(datum!),
    });
    if (apiResponse.status == Status.SUCCESS) {

      print("Menge erfolgreich hinzugefügt!");

      int mengen_id = int.parse(apiResponse.body!);

      widget.selectedArticle.mengenListe!.add(MengeDTO(mengen_id: mengen_id, artikel_id: widget.selectedArticle.artikel_id! , datum: datum.toString(), menge: int.parse(mengeTextController.text.trim())));

      int ist = 0;
      for (MengeDTO m in widget.selectedArticle.mengenListe!) {
        ist += m.menge;
      }
      widget.selectedArticle.istmenge = ist;


      setState(() {

        mengeTextController.text = "0";
        datum = null;
        widget.selectedArticle.mengenListe!.sort((a, b) =>  HelperUtil.getDifferenceDates(a.datum).compareTo( HelperUtil.getDifferenceDates(b.datum)));

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

      widget.selectedArticle.mengenListe!.remove(mengeDTO);

      int ist = 0;
      for (MengeDTO m in widget.selectedArticle.mengenListe!) {
        ist += m.menge;
      }
      widget.selectedArticle.istmenge = ist;

      setState(() {
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
    }
  }

}





