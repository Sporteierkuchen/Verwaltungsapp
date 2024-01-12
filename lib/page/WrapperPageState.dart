
import 'package:flutter/material.dart';

abstract class WrapperPageState<T extends StatefulWidget> extends State<T> {
  Widget getContent();

  @override
  Widget build(BuildContext context) {
    print("Build");
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Expanded(
          child:
              Container(padding: const EdgeInsets.only(top: 10, left: 10, right: 10), child: getContent()))
    ])));
  }
}
