import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maw/pages/uploadImage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../../helper.dart';
import '../../config.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool loading = false;
  bool _obsecureText = true;
  String imageUser = "";
  TextEditingController _nama = TextEditingController();
  TextEditingController _alamat = TextEditingController();
  TextEditingController _noHp = TextEditingController();
  TextEditingController _namaUp3 = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final Helper helper = new Helper();
  FirebaseMessaging fm = FirebaseMessaging();

  _ProfilState() {
    fm.configure(
      onLaunch: (Map<String, dynamic> msg) async {
        // print("ketika sedang berjalan");
        // print(msg);

        if (msg['data']['screen'] == 'list_trx' &&
            msg['notification']['body'] != null) {
          helper.alertLog(msg['notification']['body']);
        } else if (msg['data']['screen'] == 'list_notif') {
          helper.alertLog(msg['notification']['body']);
        }
      },
      onResume: (Map<String, dynamic> msg) async {
        // print("ketika sedang berjalan");
        // print(msg);

        if (msg['data']['screen'] == 'list_trx' &&
            msg['notification']['body'] != null) {
          helper.alertLog(msg['notification']['body']);
        } else if (msg['data']['screen'] == 'list_notif') {
          helper.alertLog(msg['notification']['body']);
        }
      },
      onMessage: (Map<String, dynamic> msg) async {
        // print("ketika sedang berjalan");
        // print(msg);
        if (msg['data']['screen'] == 'list_trx' &&
            msg['notification']['body'] != null) {
          helper.alertLog(msg['notification']['body']);
        } else if (msg['data']['screen'] == 'list_notif') {
          helper.alertLog(msg['notification']['body']);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    _getCurrentUser();
  }

  void _showPassword() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  _getCurrentUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString("id");
    final response = await http
        .post(Config.BASE_URL + "getCurrentUser", body: {"id": userId});
    final res = jsonDecode(response.body);
    print(res);
    if (res['status'] == 200) {
      setState(() {
        loading = false;
        imageUser = res['foto'];
        _nama.text = res['nama'];
        _alamat.text = res['alamat'];
        _noHp.text = res['no_hp'];
        _namaUp3.text = res['level'];
        _username.text = res['username'];
        _password.text = res['password'];
      });
    } else {
      setState(() {
        loading = true;
      });
    }
  }

  _saveProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString("id");
    final response =
        await http.post(Config.BASE_URL + "updateProfileUser", body: {
      "id": userId,
      "nama": _nama.text.toString(),
      "alamat": _alamat.text.toString(),
      "noHp": _noHp.text.toString(),
      "password": _password.text.toString()
    });
    final res = jsonDecode(response.body);
    if (res["status"] == 200) {
      setState(() {
        loading = false;
        helper.alertSuccess(res['message'], context);
      });
    } else {
      loading = true;
      helper.alertError(res['message'], context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf4f4f4),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF0c53a0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(
                  color: Color(0xFF306bdd),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
                child: Center(
                  child: imageUser == null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.white,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UploadImageDemo(text: "0")));
                              },
                              child: Image.asset(
                                "images/user-default.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 90,
                            height: 90,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UploadImageDemo(text: "0")));
                              },
                              child: imageUser == null
                                  ? Image.asset(
                                      "images/user-default.png",
                                      fit: BoxFit.cover,
                                    )
                                  : CircleAvatar(
                                      radius: 0,
                                      backgroundImage: NetworkImage(
                                        Config.BASE_URL_IMAGE +
                                            "image/profil_user/$imageUser",
                                        scale: 10,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                ),
              ),
              Card(
                margin: EdgeInsets.only(
                    top: 10.0, left: 10.0, right: 10.0, bottom: 50.0),
                elevation: 3.0,
                child: Container(
                  child: Column(
                    children: [
                      ListTile(
                        title: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _nama,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              labelText: "Nama Lengkap",
                              labelStyle: TextStyle(
                                color: Color(0xFF70747F),
                              ),
                              hintText: "Nama Lengkap",
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
                      ListTile(
                        title: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _alamat,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              labelText: "Alamat",
                              labelStyle: TextStyle(
                                color: Color(0xFF70747F),
                              ),
                              hintText: "Alamat",
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
                      ListTile(
                        title: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _noHp,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              labelText: "No. Telp",
                              labelStyle: TextStyle(
                                color: Color(0xFF70747F),
                              ),
                              hintText: "No. Telp",
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
                      ListTile(
                        title: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _namaUp3,
                            readOnly: true,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              labelText: "Level Pengguna",
                              labelStyle: TextStyle(
                                color: Color(0xFF70747F),
                              ),
                              hintText: "Level Pengguna",
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
                      ListTile(
                        title: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _username,
                            readOnly: true,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              labelText: "Nama Pengguna",
                              labelStyle: TextStyle(
                                color: Color(0xFF70747F),
                              ),
                              hintText: "Nama Pengguna",
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
                      ListTile(
                        title: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _password,
                            obscureText: _obsecureText,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _showPassword();
                                },
                                icon: _obsecureText == true
                                    ? Icon(
                                        Icons.visibility,
                                        color: Color(0xFF70747F),
                                      )
                                    : Icon(Icons.visibility_off,
                                        color: Color(0xFF70747F)),
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
                      ListTile(
                        title: GestureDetector(
                          onTap: () => _saveProfile(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.8),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(8.0),
                            margin:
                                EdgeInsets.only(left: 15, top: 5, right: 15),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                "Simpan",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
