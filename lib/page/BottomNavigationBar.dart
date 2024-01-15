import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../dto/UserDto.dart';
import '../util/PersistenceUtil.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import 'ProfilePage.dart';
import 'RegistrationPage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool loadedData = false;
  UserDto? userDTO;

  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    ProfilePage(),
  ];

  List<BottomNavigationBarItem> getItems() {
    return [
      getStartIcon(_currentIndex == 0),
      getProfileIcon(_currentIndex == 1),
    ];
  }

  @override
  void initState() {
    super.initState();
    print("App Start! init state");

    loadCustomerData().whenComplete(() => setState(() {
          loadedData = true;
          // Update your UI with the desired changes.
        }));
  }

  Future<void> loadCustomerData() async {
    userDTO = await PersistenceUtil.getUser();
    // LiveApiRequest<CustomerDto> liveApiRequest =
    //     LiveApiRequest<CustomerDto>(path: "/customer/getInfo");
    // ApiResponse apiResponse = await liveApiRequest.executeGet();
    // if (apiResponse.status == Status.SUCCESS) {
    //   CustomerDto customerDto =
    //       CustomerDto.fromJson(jsonDecode(apiResponse.body!));
    //   custDTO = customerDto;
    //   await PersistenceUtil.setCustomer(customerDto);
    // } else if (apiResponse.status == Status.EXCEPTION) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     duration: Duration(seconds: 2),
    //     content: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.max,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         const Padding(
    //           padding: EdgeInsets.only(left: 0, right: 5, top: 0, bottom: 0),
    //           child:
    //               Icon(color: Colors.orange, size: 30, Icons.warning_outlined),
    //         ),
    //         Expanded(
    //           child: Align(
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               AppLocalizations.of(context).exception,
    //               textAlign: TextAlign.center,
    //               softWrap: true,
    //               style: const TextStyle(
    //                 height: 0,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.orange,
    //                 fontSize: 16,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ));
    // } else if (apiResponse.status == Status.ERROR) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     duration: Duration(seconds: 2),
    //     content: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.max,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         const Padding(
    //           padding: EdgeInsets.only(left: 0, right: 5, top: 0, bottom: 0),
    //           child: Icon(
    //               color: Colors.red, size: 30, Icons.error_outline_outlined),
    //         ),
    //         Expanded(
    //           child: Align(
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               AppLocalizations.of(context).error,
    //               textAlign: TextAlign.center,
    //               softWrap: true,
    //               style: const TextStyle(
    //                 height: 0,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.red,
    //                 fontSize: 16,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ));
    // }

    //return null;
  }

  @override
  Widget build(BuildContext context) {
    //  if (loadedData && custDTO!=null && custDTO?.email != null && custDTO?.password != null) {
    if (loadedData && userDTO != null) {
      return Scaffold(
        body: _screens.elementAt(_currentIndex),
        bottomNavigationBar: SizedBox(
          height: (MediaQuery.of(context).orientation == Orientation.landscape)
              ? MediaQuery.of(context).size.height * 0.16
              : MediaQuery.of(context).size.height * 0.09,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: getItems(),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xFFFFFFFF),
            selectedItemColor: Color(0xFF7B1A33),
            unselectedItemColor: Color(0xFFCAB69E),
            //iconSize: 10,
            onTap: (value) {

              if(_currentIndex != value){

                setState(() {
                  _currentIndex = value;
                });

              }

            },
          ),
        ),
      );
    }
    //else if(loadedData && (custDTO== null || custDTO?.email == null || custDTO?.password == null)){
    else if (loadedData && (userDTO == null)) {
      print("Fehler Datenbank...");

      PersistenceUtil.logout();
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Es ist ein Fehler in der Datenbank aufgetreten...",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        textStyle: const TextStyle(fontSize: 20),
                        backgroundColor: const Color(0xFF5B259F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Konto erstellen"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        textStyle: const TextStyle(fontSize: 20),
                        backgroundColor: const Color(0xFF5B259F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Anmelden"),
                    ),
                  ),
                ]),
          ),
        ),
      );
    } else {
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
                  color: Color(0xFF7B1A33),
                  size: 100,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  BottomNavigationBarItem getStartIcon(bool selected) {
    return BottomNavigationBarItem(
      icon: Container(
          child: SvgPicture.asset(
        'lib/images/home.svg',
        colorFilter: ColorFilter.mode(
            selected
                ? const Color(0xFF7B1A33)
                : const Color(0xFFCAB69E),
            BlendMode.srcIn),
        width: (MediaQuery.of(context).orientation == Orientation.landscape)
            ? MediaQuery.of(context).size.height * 0.06
            : MediaQuery.of(context).size.height * 0.04,
        height: (MediaQuery.of(context).orientation == Orientation.landscape)
            ? MediaQuery.of(context).size.height * 0.06
            : MediaQuery.of(context).size.height * 0.04,
      )),
      label: "Start",
    );
  }

  BottomNavigationBarItem getProfileIcon(bool selected) {
    return BottomNavigationBarItem(
      icon: Container(
          child: SvgPicture.asset(
        'lib/images/profile.svg',
        colorFilter: ColorFilter.mode(
            selected
                ? const Color(0xFF7B1A33)
                : const Color(0xFFCAB69E),
            BlendMode.srcIn),
        width: (MediaQuery.of(context).orientation == Orientation.landscape)
            ? MediaQuery.of(context).size.height * 0.06
            : MediaQuery.of(context).size.height * 0.04,
        height: (MediaQuery.of(context).orientation == Orientation.landscape)
            ? MediaQuery.of(context).size.height * 0.06
            : MediaQuery.of(context).size.height * 0.04,
      )),
      label: "Profil",
    );
  }
}
