import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:maw/pages/functional.dart';
import '../../config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Absen extends StatefulWidget {
  final String title = "Upload Image Demo";

  @override
  AbsenState createState() => AbsenState();
}

class AbsenState extends State<Absen> {
  Future<File> file;
  String status = '';
  String idUser = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  DateTime dateTime = DateTime.now();
  chooseImage() {
    setState(() {
      // ignore: deprecated_member_use
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  chooseImages() {
    setState(() {
      // ignore: deprecated_member_use
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var idUser = pref.getString("id");
    String linkToServer = "absenSales";

    http.post(Config.BASE_URL + linkToServer, body: {
      "image": base64Image,
      "name": fileName,
      "id": idUser
    }).then((result) {
      final data = jsonDecode(result.body);
      setStatus(result.statusCode == 200 ? data['pesan'] : errMessage);
      if (data['status'] == "1") {
        helper.alertSuccess(data['pesan'], context);
      } else {
        helper.alertSuccess(data['pesan'], context);
      }
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.cover,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.40,
            child: Image.asset(
              "images/no-image.png",
              fit: BoxFit.contain,
            ),
          );
        }
      },
    );
  }

  Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            showImage(),
            GestureDetector(
              onTap: chooseImages,
              child: Container(
                  color: Colors.red,
                  margin:
                      EdgeInsets.symmetric(horizontal: 34.0, vertical: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera, color: Colors.white),
                      Text(
                        'Ambil Foto Selfie',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ))),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
                child: Center(
                    child: Text(DateFormat('dd/MM/yyyy H:mm:ss')
                        .format(dateTime)
                        .toString()))),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: startUpload,
              child: Container(
                  color: Colors.blue,
                  margin: EdgeInsets.symmetric(horizontal: 34.0),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Center(
                      child: Text(
                    'Absen Sekarang',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ))),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
