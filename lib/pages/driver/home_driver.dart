import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maw/pages/driver/home.dart';
import 'package:maw/pages/functional.dart';
import 'package:maw/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../../helper.dart';

class HomeDriver extends StatefulWidget {
  @override
  _HomeDriverState createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {
  bool prosesLogout = false;
  final Helper helper = Helper();
  int bottomNavBarIndex;
  int ntf = 0;
  PageController pageController;
  Timer timer;
  final Functional functional = Functional();
  @override
  void initState() {
    super.initState();
    bottomNavBarIndex = 0;
    pageController = PageController(initialPage: bottomNavBarIndex);
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      functional.sendLocation();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  logOut() async {
    setState(() {
      prosesLogout = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idUser = preferences.getString("id");
    var response = await http.get(Config.BASE_URL + "logOut?id=$idUser");
    if (response.statusCode == 200) {
      print('about http: ${response.body}.');
      setState(() {
        preferences.remove("id");
        preferences.remove("nama");
        preferences.remove("userId");
        preferences.remove("alamat");
        preferences.remove("noHp");
        preferences.remove("level");
      });
      setState(() {
        prosesLogout = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      helper.alertLog("Anda Telah Log Out !");
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: BottomNavyBar(
          showElevation: true,
          itemCornerRadius: 24,
          selectedIndex: bottomNavBarIndex,
          onItemSelected: (index) => setState(() {
            bottomNavBarIndex = index;
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
                icon: Icon(Icons.pages),
                title: Text('Home',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                activeColor: Color(0xFF306bdd),
                inactiveColor: Color(0xFF70747F),
                textAlign: TextAlign.start),
            BottomNavyBarItem(
                icon: Stack(children: <Widget>[
                  Icon(
                    bottomNavBarIndex == 1
                        ? Icons.notifications
                        : Icons.notifications_none,
                  ),
                  Positioned(
                    // draw a red marble
                    top: 0.0,
                    right: 0.0,
                    child: Visibility(
                      visible: ntf == 0 ? false : true,
                      child: new Icon(Icons.brightness_1,
                          size: 12.0,
                          color: ntf != 0 ? Colors.red : Colors.transparent),
                    ),
                  )
                ]),
                title: Text('Notification',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                activeColor: Color(0xFF306bdd),
                inactiveColor: Color(0xFF70747F),
                textAlign: TextAlign.start),
            BottomNavyBarItem(
                icon: Icon(Icons.person_outline),
                title: Text('Akun',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                activeColor: Color(0xFF306bdd),
                inactiveColor: Color(0xFF70747F),
                textAlign: TextAlign.start),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Image.asset(
                    "images/logo_maw.png",
                    width: 100.85,
                    height: 50.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: bottomNavBarIndex == 0
                      ? Text(
                          "Home",
                          style: GoogleFonts.poppins(
                              color: Color(0xFF2c406e),
                              fontWeight: FontWeight.w500,
                              fontSize: 19.0),
                        )
                      : bottomNavBarIndex == 1
                          ? Text(
                              "Notification",
                              style: GoogleFonts.poppins(
                                  color: Color(0xFF2c406e),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19.0),
                            )
                          : Text(
                              "Profile",
                              style: GoogleFonts.poppins(
                                  color: Color(0xFF2c406e),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19.0),
                            ),
                )
              ],
            ),
          ),
        ),
        elevation: 2,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              if (value == 0) {
                logOut();
              }
            },
            offset: const Offset(0, 300),
            icon: Icon(Icons.settings, color: Color(0xFF2c406e)),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app, color: Colors.black),
                    SizedBox(width: 8.0),
                    Text("Logout",
                        style: GoogleFonts.poppins(
                            fontSize: 14.0, color: Color(0xFF70747F))),
                  ],
                ),
              ),
            ],
          ),
        ],

        //  backgroundColor: Colors.deepPurple,
        backgroundColor: Colors.white,
      ),
      body: Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Stack(
          children: [
            PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  bottomNavBarIndex = index;
                });
              },
              children: [
                Home(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
