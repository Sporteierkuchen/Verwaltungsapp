import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:verwaltungsapp/dto/ArticleDTO.dart';
import 'package:verwaltungsapp/page/MainPage.dart';
import '../dto/MengeDTO.dart';
import '../util/LiveApiRequest.dart';

class LoadingPage extends StatefulWidget {

  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  List<ArticleDTO> articleList = [];

  bool loadedData = false;
  bool loadedDataSuccessful = false;

  @override
  void initState() {
    super.initState();
    print("Init State Loading-Page");

    loadData().whenComplete(() => setState(() {

       loadedData = true;

    }));
  }

  @override
  dispose() {
    print("Disposed Loading-Page");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (loadedData && loadedDataSuccessful) {

       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(articleList: articleList),
          ),
        );

       });

      return getLoadingPage();
    }
    else if (loadedData && loadedDataSuccessful == false  ) {
      return Scaffold(

        resizeToAvoidBottomInset: false ,
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
    } else if(loadedData == false) {
        return getLoadingPage();
    }
    else{
      return Container();
    }
  }

 Widget getLoadingPage(){
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

 }





