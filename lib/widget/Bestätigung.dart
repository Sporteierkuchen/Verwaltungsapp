
import 'package:flutter/material.dart';

class BestaetigungsDialog extends StatefulWidget {

  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  BestaetigungsDialog({Key? key, required this.title, required this.message, required this.onConfirm, required this.onCancel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BestaetigungsDialogState();
}

class _BestaetigungsDialogState extends State<BestaetigungsDialog> {

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:

      Padding(
        padding: const EdgeInsets.only(top: 8,bottom: 15,left: 10,right: 10),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 25,
              height: 0,
              color: Colors.white,
              fontWeight: FontWeight.bold),

        ),
      ),
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
      content: Container(
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        //color: Colors.white,
        child:
        Text(
          widget.message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 22,
              height: 0,
              color: Colors.white,
              fontWeight: FontWeight.normal),

        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            ElevatedButton(
              onPressed: () async {

                widget.onConfirm();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                side: const BorderSide(color: Colors.white, width: 2),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // Text Color (Foreground color)
              ),
              child: const Text(
                'Ja',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                widget.onCancel();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.white, width: 2),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // Text Color (Foreground color)
              ),
              child: const Text(
                'Nein',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black
                ),
              ),
            )


          ],
        ),

      ],
    );
  }
}