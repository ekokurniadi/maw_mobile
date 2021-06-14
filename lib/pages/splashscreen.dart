import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maw/pages/driver/home_driver.dart';
import 'package:maw/pages/login.dart';
import 'package:maw/pages/owner/home_owner.dart';
import 'package:maw/pages/sales/home_sales.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  String idUser = '';
  String role = '';

  ambilProfil() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var xUser = sharedPreferences.get("id");
    var xRole = sharedPreferences.get("level");

    print("ID USER : $xUser");
    print("Hak Akses : $xRole");
    setState(() {
      idUser = xUser;
      role = xRole;
    });
  }

  @override
  void initState() {
    super.initState();
    startSplashScreen();
    ambilProfil();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      // cek ada sesion login saat ini
      if (idUser == null && role == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else if (role == "Sales") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeSales()));
      } else if (role == "Driver") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeDriver()));
      } else if (role == "Owner") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeOwner()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Image.asset(
                  "images/logo_maw.png",
                  width: 280.0,
                  height: 180.0,
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "MAW Mobile",
                    style: GoogleFonts.poppins(
                      color: Color(0xFF0c53a0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
