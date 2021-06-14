import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maw/pages/driver/home_driver.dart';
import 'package:maw/pages/owner/home_owner.dart';
import 'package:maw/pages/sales/home_sales.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../helper.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();
  final Helper helper = new Helper();
  bool prosesLogin = false;
  bool _obsecureText = true;
  FirebaseMessaging fm = FirebaseMessaging();
  String tokenFcm = "";

  _LoginState() {
    fm.getToken().then((value) => tokenFcm = value);
    fm.configure();
  }

  _loginAction() async {
    setState(() {
      prosesLogin = true;
    });
    final response = await http.post(Config.BASE_URL + "login", body: {
      "username": _usernameControl.text,
      "password": _passwordControl.text,
      "token": tokenFcm
    });
    print(response.body);
    final data = jsonDecode(response.body);
    print("hasil login: $data");

    String value = data['status'];
    String message = data['pesan'];
    String idUser = data['id'];
    String nama = data['nama'];
    String userId = data['user_id'];
    String alamat = data['alamat'];
    String noHp = data['noHp'];
    String level = data['level'];

    if (value == "1" && level == "Sales") {
      setState(() {
        savePref(idUser, nama, userId, alamat, noHp, level);
      });
      setState(() {
        prosesLogin = false;
      });
      helper.alertLog(message);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeSales()));
    } else if (value == "1" && level == "Driver") {
      setState(() {
        savePref(idUser, nama, userId, alamat, noHp, level);
      });
      setState(() {
        prosesLogin = false;
      });
      helper.alertLog(message);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeDriver()));
    } else if (value == "1" && level == "Owner") {
      setState(() {
        savePref(idUser, nama, userId, alamat, noHp, level);
      });
      setState(() {
        prosesLogin = false;
      });
      helper.alertLog(message);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeOwner()));
    } else if (value == "0") {
      setState(() {
        prosesLogin = false;
      });
      helper.alertError(message, context);
    }
  }

  savePref(String idUser, String nama, String userId, String alamat,
      String noHp, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("id", idUser);
      preferences.setString("nama", nama);
      preferences.setString("userId", userId);
      preferences.setString("alamat", alamat);
      preferences.setString("noHp", noHp);
      preferences.setString("level", level);
    });
  }

  @override
  void initState() {
    super.initState();
    prosesLogin = false;
  }

  void _showPassword() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Color(0xff2c274c),
                    //     Color(0xff46426c),
                    //   ],
                    //   begin: Alignment.bottomCenter,
                    //   end: Alignment.topCenter,
                    // ),
                    color: Color(0xFF306bdd),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Image.asset(
                            "images/logo_maw.png",
                            width: 70.0,
                            height: 70.0,
                          ),
                        ),
                      ),
                      Text(
                        "Multi Andalan Wisesa",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                child: Card(
                  elevation: 5.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "User Authentication",
                            style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                color: Color(0xff2c274c),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              controller: _usernameControl,
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Color(0xFF70747F),
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                  letterSpacing: 1.0),
                              decoration: InputDecoration(
                                labelText: "Username",
                                labelStyle: TextStyle(
                                  color: Color(0xFF70747F),
                                ),
                                hintText: "Username",
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFC9CFDF),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 0.0, bottom: 0.0, top: 0.0),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFC9CFDF),
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFC9CFDF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: 5,
                          ),
                        ),
                        ListTile(
                          title: Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              controller: _passwordControl,
                              obscureText: _obsecureText,
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Color(0xFF70747F),
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                  letterSpacing: 1.0),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _showPassword();
                                  },
                                  icon: _obsecureText == true
                                      ? Icon(Icons.lock_open)
                                      : Icon(Icons.lock),
                                ),
                                labelText: "Password",
                                labelStyle: TextStyle(
                                  color: Color(0xFF70747F),
                                ),
                                hintText: "Password",
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFC9CFDF),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 0.0, bottom: 0.0, top: 0.0),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFC9CFDF),
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFC9CFDF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: 2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _loginAction();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 15, top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFFF0303),
                            ),
                            child: Center(
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 25),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF70747F),
                          ),
                          child: Center(
                            child: Text(
                              "CANCEL",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 50.0),
                child: Center(
                  child: Text(
                    "App Version 1.0",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Color(0xff2c274c),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        inAsyncCall: prosesLogin,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF0c53a0)),
        ),
      ),
    );
  }
}
