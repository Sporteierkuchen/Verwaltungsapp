import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../Klassen/Meldung.dart';
import '../util/HelperUtil.dart';
import '../widget/TextInput.dart' as Textfeld;

class EditPage extends StatefulWidget {

  final String articleId;
  const EditPage({Key? key,required this.articleId}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  bool loadedData = true;

  final nameTextController = TextEditingController();
  final sollmengeTextController = TextEditingController();
  final warnzeitTextController = TextEditingController();

  CroppedFile? file;

  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    print("Init State Edit-Page");

  }

  @override
  dispose() {
    print("Disposed Edit-Page");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("Build EditPage");

    return

     PopScope(
     canPop: loadedData ? true : false ,
        child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child:

          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.
            collection('Article').doc(widget.articleId).snapshots(),

            builder: (context, snapshot) {

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error: ${snapshot.error}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.red)),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: CircularProgressIndicator(color: Colors.red,),
                );
              }

              DocumentSnapshot<Object?>? article;

              // Prüfen, ob das Dokument existiert
              if (!snapshot.hasData || !snapshot.data!.exists) {
                print("Artikel wurde gelöscht!");

                // Navigator.pop aufrufen, wenn das Dokument nicht existiert
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                });

              }
              else{

                article =snapshot.data;

                nameTextController.text= article!['name'];
                sollmengeTextController.text= article['sollmenge'].toString();
                warnzeitTextController.text= article['warnzeit'].toString();
              }

              return

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

                    Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(100), // Image radius
                                child:

                                article!=null ?

                                article['logopath'].isNotEmpty
                                    ?
                                Image.network(
                                  article['logopath'],
                                  fit: BoxFit.cover,
                                  gaplessPlayback: true,
                                  // filterQuality: FilterQuality.high,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Leeres Bild oder alternative UI-Komponente im Fehlerfall anzeigen
                                    return Image.asset(
                                      "lib/images/articles/empty.png",
                                      fit: BoxFit.cover,
                                    );
                                  },

                                  )
                                    : Image.asset(
                                  "lib/images/articles/empty.png",
                                  fit: BoxFit.cover,
                                )
                                :
                                Image.asset(
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
                                  onTap: () async {

                                    if (loadedData) {

                                      await pickImage(ImageSource.gallery);
                                      await uploadProfileImage(file,article!['logopath']);

                                    }

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
                                  onTap: () async {

                                    if (loadedData) {

                                      await pickImage(ImageSource.camera);
                                      await uploadProfileImage(file,article!['logopath']);

                                    }

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

                    SizedBox(
                      width: 300,
                      height: 50,
                      child: Textfeld.TextInput(
                        label: "Artikelname",
                        obscureText: false,
                        controller:
                        nameTextController,
                        icon:
                        const Icon(Icons.list_alt_outlined),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: Textfeld.TextInput(
                        label: "Sollmenge",
                        obscureText: false,
                        controller:
                        sollmengeTextController,
                        icon:
                        const Icon(Icons.add),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: Textfeld.TextInput(
                        label: "Warnzeit in Tagen",
                        obscureText: false,
                        controller:
                        warnzeitTextController,
                        icon:
                        const Icon(Icons.timer_rounded),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            ElevatedButton(
                              onPressed: () async {

                                if (loadedData) {

                                  setState(() {
                                    loadedData = false;
                                  });

                                  if (checkUserInputArticle()) {

                                    if(await editArticle()){
                                      file= null;
                                      nameTextController.text="";
                                      sollmengeTextController.text="";
                                      warnzeitTextController.text="";

                                      Navigator.pop(context);
                                    }

                                  } else {
                                    print("Fehler Eingabe!");
                                    HelperUtil.getToast(
                                        meldung: Meldung(
                                            meldungsart: Meldungsart.WARNING,
                                            text: errorMessage),
                                        context: context);
                                  }

                                  setState(() {
                                    loadedData = true;
                                  });

                                }

                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.green,
                                side: const BorderSide(
                                    color: Colors.black, width: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // Text Color (Foreground color)
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.save),
                                  Text(
                                    'Speichern',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              width: 50,
                            ),

                            ElevatedButton(
                              onPressed: () async {

                                if (loadedData) {
                                  print("Abbrechen!");

                                  file = null;
                                  nameTextController.text = "";
                                  sollmengeTextController.text = "";
                                  warnzeitTextController.text = "";

                                  Navigator.pop(context);

                                }

                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.red,
                                side: const BorderSide(
                                    color: Colors.black, width: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // Text Color (Foreground color)
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.cancel_outlined),
                                  Text(
                                    'Abbrechen',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                );

            },
          ),
        ),
            ),
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

  Future pickImage(ImageSource source) async {
    if (loadedData) {
      try {
        final image =
        await ImagePicker().pickImage(source: source);

        if (image == null) return;

        CroppedFile? imgcrop = await _cropImage(imageFile: File(image.path));
        if (imgcrop == null) return;

        setState(() {
          file = imgcrop;
        });

      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
      }
    }
  }

  Future<CroppedFile?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: const [CropAspectRatioPreset.original]);
    if (croppedImage == null) return null;
    return croppedImage;
  }

  Future<void> uploadProfileImage(CroppedFile? imageFile, String logopath) async {

    if(imageFile == null){
      return;
    }

    try {

      if(logopath.isNotEmpty){

        final storageRef = FirebaseStorage.instance.refFromURL(logopath);
        await storageRef.delete();

      }

      // Generate a unique ID for the video
      String uniqueId = const Uuid().v4();

      final ref = FirebaseStorage.instance
          .ref()
          .child('article_pictures')
          .child('$uniqueId.jpg');

      await ref.putFile(File(imageFile.path));

      // Holen der Download-URL
      final downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('Article').doc(widget.articleId).update({
        'logopath': downloadUrl,
      });

      file= null;

      print("Artikelbild erfolgreich bearbeitet.");
      HelperUtil.getToast(
        meldung: Meldung(
            meldungsart: Meldungsart.SUCCESS,
            text: "Das Artikelbild wurde erfolgreich bearbeitet!"),
        context: context,
      );

    } catch (e) {
      print('Fehler beim Bearbeiten des Artikelbildes: $e');
      HelperUtil.getToast(
        meldung: Meldung(
            meldungsart: Meldungsart.ERROR,
            text: "Fehler beim Bearbeiten des Artikelbildes: ${e.toString()}"),
        context: context,
      );
    }

  }

  Future<bool> editArticle() async {
    try {

      await FirebaseFirestore.instance.collection('Article').doc(widget.articleId).update({

        'name': nameTextController.text.trim(), // Titel des Videos
        'sollmenge': int.parse(sollmengeTextController.text.trim()),
        'warnzeit': int.parse(warnzeitTextController.text.trim()),

      });

      print("Artikel erfolgreich bearbeitet.");
      HelperUtil.getToast(
        meldung: Meldung(
            meldungsart: Meldungsart.SUCCESS,
            text: "Der Artikel wurde erfolgreich bearbeitet!"),
        context: context,
      );

      return true;
    } catch (e) {
      print("Fehler beim Bearbeiten des Artikels: $e");
      HelperUtil.getToast(
        meldung: Meldung(
            meldungsart: Meldungsart.ERROR,
            text: "Fehler beim Bearbeiten des Artikels: ${e.toString()}"),
        context: context,
      );
      return false;
    } finally {}
  }

 }





