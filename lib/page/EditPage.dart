import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verwaltungsapp/dto/ArticleDTO.dart';
import '../util/LiveApiRequest.dart';

class EditPage extends StatefulWidget {
  final ArticleDTO selectedArticle;
  const EditPage({Key? key,  required this.selectedArticle}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  bool loadedData = true;

  String image = "";
  final nameTextController = TextEditingController();
  final sollmengeTextController = TextEditingController();
  final warnzeitTextController = TextEditingController();

  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    print("Init State Edit-Page");

    image = widget.selectedArticle.logo;
    nameTextController.text = widget.selectedArticle.name;
    sollmengeTextController.text = widget.selectedArticle.sollmenge.toString();
    warnzeitTextController.text = widget.selectedArticle.warnzeit.toString();

  }

  @override
  dispose() {
    print("Disposed Edit-Page");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return

     PopScope(
     canPop: loadedData ? true : false ,
        child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child:

          Container(
            color: Colors.transparent,
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

                                setState(() {
                                  loadedData = false;
                                });


                                if (checkUserInputArticle()) {
                                  await updateArticle(widget.selectedArticle.artikel_id!);
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


                                }

                                setState(() {
                                  loadedData = true;
                                });

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

                                Navigator.pop(context);

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
          ) ,

        ),
            ),
      );

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

        widget.selectedArticle.logo = image;
        widget.selectedArticle.name = nameTextController.text.trim();
        widget.selectedArticle.sollmenge = int.parse(sollmengeTextController.text.trim());
        widget.selectedArticle.warnzeit = int.parse(warnzeitTextController.text.trim());

        image = "";
        nameTextController.text = "";
        sollmengeTextController.text = "";
        warnzeitTextController.text = "";

        Navigator.pop(context);

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


 }





