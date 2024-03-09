import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verwaltungsapp/dto/ArticleDTO.dart';
import '../dto/MengeDTO.dart';
import '../util/LiveApiRequest.dart';

class EntnehmenPage extends StatefulWidget {
  final ArticleDTO selectedArticle;
  final MengeDTO selectedMenge;
  const EntnehmenPage({Key? key, required this.selectedArticle, required this.selectedMenge}) : super(key: key);

  @override
  State<EntnehmenPage> createState() => _EntnehmenPageState();
}

class _EntnehmenPageState extends State<EntnehmenPage> {

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
    print("Disposed Entnehmen-Page");
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

                        Padding(
                          padding: const EdgeInsets.only( top: 10),
                          child: Text(widget.selectedArticle!.name,
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
                                            child: Text(widget.selectedMenge.menge.toString(),
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
                                                    DateFormat('dd.MM.yyyy').format(DateTime.parse(widget.selectedMenge!.datum)),
                                                    style: const TextStyle(
                                                      height: 0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              getDifferenceDates(widget.selectedMenge!.datum) > widget.selectedArticle!.warnzeit
                                                  ? const Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 50,
                                              )
                                                  : Container(),

                                              getDifferenceDates(widget.selectedMenge!.datum) <= widget.selectedArticle!.warnzeit  &&  getDifferenceDates(widget.selectedMenge!.datum) >= 0
                                                  ? const Icon(
                                                Icons.warning,
                                                color: Colors.orange,
                                                size: 50,
                                              )
                                                  : Container(),

                                              getDifferenceDates(widget.selectedMenge!.datum) < 0
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

                                              if(menge<0 || menge > widget.selectedMenge!.menge){
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

                                              if(menge<0 || menge > widget.selectedMenge!.menge){
                                                entnehmenTextController.text = "0";
                                              }
                                              else if(menge == widget.selectedMenge!.menge){
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

                                  if(widget.selectedMenge.menge == int.parse(entnehmenTextController.text)){
                                    await deleteMenge(widget.selectedMenge);
                                  }
                                  else{
                                    await entnehmeMenge(widget.selectedMenge, widget.selectedMenge.menge - int.parse(entnehmenTextController.text.trim()));
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


                        // SizedBox(width: MediaQuery.of(context).size.width* 0.05),


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
        if (menge > widget.selectedMenge!.menge) {
          errorMessage += "Du kannst höchstens ${widget.selectedMenge!.menge} Artikel entnehmen!\n";
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
      for (MengeDTO m in widget.selectedArticle.mengenListe!) {
        ist += m.menge;
      }
      widget.selectedArticle.istmenge = ist;

      entnehmenTextController.text = "0";
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





