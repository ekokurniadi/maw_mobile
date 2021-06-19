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
import 'package:geolocator/geolocator.dart';

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
  double officeLat;
  double officeLong;
  double distance;
  String jarakOnDevice = "";
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

  sendLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final response = await http.post(Config.BASE_URL + "getLokasiKantor");
    final res = jsonDecode(response.body);
    setState(() {
      officeLat = double.parse(res['latitude']);
      officeLong = double.parse(res['latitude']);
    });
    print(res);
    double distanceInMeters = await Geolocator().distanceBetween(
        -6.59738178531859,
        106.76834551261724,
        -6.5973977720028545,
        106.76830729113959);
    // double distanceInMeters = await Geolocator().distanceBetween(
    //     position.latitude, position.longitude, officeLat, officeLong);
    setState(() {
      distance = distanceInMeters;
      jarakOnDevice = distanceInMeters.toStringAsFixed(2);
    });

    // helper.alertLog(distance.toStringAsFixed(2) + " Meter");
  }

  upload(String fileName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var idUser = pref.getString("id");
    String linkToServer = "absensi";

    http.post(Config.BASE_URL + linkToServer, body: {
      "image": base64Image,
      "name": fileName,
      "id_sales": idUser,
      "tanggal": dateTime.toString(),
      "jam": dateTime.toString(),
      "jarak": distance.toStringAsFixed(2),
    }).then((result) {
      final data = jsonDecode(result.body);
      print(data);
      setStatus(result.statusCode == 200 ? data['pesan'] : errMessage);
      if (data['status'] == 200) {
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
          return GestureDetector(
            onTap: chooseImages,
            child: Flexible(
              child: Image.file(
                snapshot.data,
                fit: BoxFit.contain,
              ),
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return GestureDetector(
            onTap: chooseImages,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.40,
              child: Image.asset(
                "images/no-image.png",
                fit: BoxFit.contain,
              ),
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
    sendLocation();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      sendLocation();
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Jarak lokasi anda ke kantor : " + jarakOnDevice + " M",
                  style: GoogleFonts.poppins(),
                ),
              ),
              showImage(),
              // GestureDetector(
              //   onTap: chooseImages,
              //   child: Container(
              //       color: Colors.red,
              //       margin:
              //           EdgeInsets.symmetric(horizontal: 34.0, vertical: 10.0),
              //       width: MediaQuery.of(context).size.width,
              //       height: 50,
              //       child: Center(
              //           child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(Icons.camera, color: Colors.white),
              //           Text(
              //             'Ambil Foto Selfie',
              //             style: GoogleFonts.poppins(
              //                 color: Colors.white, fontWeight: FontWeight.w400),
              //           ),
              //         ],
              //       ))),
              // ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                  child: Center(
                      child: Text(
                DateFormat('dd/MM/yyyy H:mm:ss').format(dateTime).toString(),
                style: GoogleFonts.poppins(color: Colors.blueGrey),
              ))),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: base64Image == null ? null : startUpload,
                child: Container(
                    color: base64Image == null ? Colors.blueGrey : Colors.red,
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
      ),
    );
  }
}
