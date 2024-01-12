
import 'package:flutter/material.dart';

import '../util/PersistenceUtil.dart';
import 'BottomNavigationBar.dart';
import 'RegistrationPage.dart';



class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    loadMain(context);
    return Container(
        //TODO splash screen image
        );
  }

  void loadMain(BuildContext context) async {
    //await PersistenceUtil.setUserUUID("123");
    PersistenceUtil.getToken().then((token) {

      if (token == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RegistrationPage()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()));
      }
    });
  }
}
