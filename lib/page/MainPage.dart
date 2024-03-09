import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:verwaltungsapp/dto/ArticleDTO.dart';
import 'package:verwaltungsapp/page/AddPage.dart';
import 'package:verwaltungsapp/page/EditPage.dart';
import 'package:verwaltungsapp/util/HelperUtil.dart';
import '../dto/MengeDTO.dart';
import '../util/LiveApiRequest.dart';
import '../widget/FilterWidget.dart';
import 'MengenPage.dart';

class MainPage extends StatefulWidget {
  final List<ArticleDTO>articleList;
  const MainPage({Key? key, required this.articleList}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool loadedData = true;

  List<bool> filterList = [true, false, false, false, false];

  List<ArticleDTO> articleListSearch = <ArticleDTO>[];
  final fieldText = TextEditingController();

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
    refresh();

      return
        PopScope(
          canPop: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false ,
            body: SafeArea(
                child:
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Row(
                        mainAxisSize: MainAxisSize.max,
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

                                        if (widget.articleList.length !=
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

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddPage(articleList: widget.articleList),
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

                                    loadedData = false;

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
                                      refresh();
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
                        child: widget.articleList.isEmpty || articleListSearch.isEmpty
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
                                            loadedData = true;

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
                                        onPressed: (value)  {
                                          if (loadedData) {
                                            print("Artikel bearbeiten!");


                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditPage(selectedArticle: articleListSearch[index]),
                                              ),
                                            ).then((value) => setState(() {}));

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

                                        articleListSearch[index].mengenListe!.sort((a, b) => HelperUtil.getDifferenceDates(a.datum).compareTo(HelperUtil.getDifferenceDates(b.datum)));

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MengenPage(selectedArticle: articleListSearch[index]),
                                          ),
                                        ).then((value) => setState(() {}));

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
                                                padding: const EdgeInsets.all(
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
                                              const SizedBox(
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
                ),
            ),
                ),
        );

  }


  void refresh() {

    articleListSearch.clear();

    for (ArticleDTO a in widget.articleList) {
      if (a.name.toLowerCase().contains(fieldText.text.toLowerCase().trim())) {

        articleListSearch.add(a);

      }
    }



    if(filterList[0] == false){

      if(filterList[1]){

        articleListSearch.removeWhere((element) => !(element.istmenge! < element.sollmenge));

      }


      if(filterList[2]){

        articleListSearch.removeWhere((element) => !isOKMenge(element));

      }

      if(filterList[3]){

        articleListSearch.removeWhere((element) => !isWarningMenge(element));

      }

      if(filterList[4]){

        articleListSearch.removeWhere((element) => !isAbgelaufenMenge(element));

      }


    }

    articleListSearch.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));

  }

  void starteSuche(String value) {
    print("Artikelsuche gestartet! Value: $value");

    if (value.trim().isNotEmpty) {
      articleListSearch.clear();

      refresh();

      setState(() {});
    } else {
      if (widget.articleList.length != articleListSearch.length) {
        print("Artikellisten sind ungleich");

        refresh();

        setState(() {});
      } else {
        print("Artikellisten sind gleich");
      }
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

      widget.articleList.remove(article);
      refresh();

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



