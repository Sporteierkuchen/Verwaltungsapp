import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final List<bool> isChecked;
  const CustomDialog({Key? key, required this.isChecked}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  final List<String> _texts = [
    "Alle Artikel anzeigen",
    "Artikel die nachgekauft werden müssen anzeigen",
    "MHD-OK Artikel anzeigen",
    "MHD-Warnung Artikel anzeigen",
    "MHD-Abgelaufen Artikel anzeigen",
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filteroptionen'),

      content: SizedBox(
       width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child:
        ListView.builder(
          shrinkWrap: true,
          itemCount: _texts.length,
          itemBuilder: (_, index) {

            return
              CheckboxListTile(
                title: Text(_texts[index]),
                value: widget.isChecked[index],

                onChanged: (val) {
                  setState(() {

                    if(index != 0){
                      widget.isChecked[0] = false;
                    }
                    else if( index == 0 &&  widget.isChecked[0] == false){
                      widget.isChecked[1] = false;
                      widget.isChecked[2] = false;
                      widget.isChecked[3] = false;
                      widget.isChecked[4] = false;
                    }

                    widget.isChecked[index] = val!;

                    if(widget.isChecked[0] == false && widget.isChecked[1] == false && widget.isChecked[2] == false && widget.isChecked[3] == false && widget.isChecked[4] == false){

                      widget.isChecked[0] = true;

                    }

                  });
                },

                controlAffinity: ListTileControlAffinity.leading,
              );

          },
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: (){  Navigator.pop(context);},
              child: const Text('OK'),
            ),

          ],
        ),

      ],
    );
  }
}