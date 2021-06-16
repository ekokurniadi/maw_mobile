import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maw/pages/sales/formPengajuan.dart';
import '../../config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Claim extends StatefulWidget {
  @override
  _ClaimState createState() => _ClaimState();
}

class _ClaimState extends State<Claim> {
  final TextEditingController controllerSearch = TextEditingController();
  bool controllerSearchValue = true;
  String filter = "";
  TextEditingController _tanggalSurvey = TextEditingController();
  List<dynamic> dataList;
  DateTime selectedDateSurvey = DateTime.now();
  Future<File> file;
  String status = '';
  String idUser = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  ScrollController _scrollController = new ScrollController();
  int page = 10;
  bool isLoading = false;
  Future<String> getTask(String filter) async {
    final response =
        await http.post(Config.BASE_URL + "getClaim", body: {"filter": filter});
    Map<String, dynamic> map = jsonDecode(response.body);
    setState(() {
      dataList = map["data"];
    });
    print(dataList);
    return "Success";
  }

  List<dynamic> dataCustomer;
  getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var url = await http.post(Config.BASE_URL + "fetch_data", body: {
        "start": "0",
        "length": index.toString(),
        "draw": "1",
        "search": "",
        "searching": "$filter",
      });
      // final response = jsonDecode(url.body);
      Map<String, dynamic> response = jsonDecode(url.body);
      print(response);
      setState(() {
        isLoading = false;
        page++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTask("");
    controllerSearchValue = true;
    getMoreData(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData(page);
      }
    });
  }

  _selectDateSurvey(BuildContext context) async {
    final DateTime pickedDateSurvey = await showDatePicker(
        context: context,
        initialDate: selectedDateSurvey,
        firstDate: DateTime(2000),
        lastDate: DateTime(2199),
        initialDatePickerMode: DatePickerMode.day);
    if (pickedDateSurvey != null && pickedDateSurvey != selectedDateSurvey)
      setState(() {
        selectedDateSurvey = pickedDateSurvey;
        _tanggalSurvey.text =
            DateFormat('dd/MM/yyyy').format(selectedDateSurvey);
      });
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

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  void myAlertCancel() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              'Pengajuan Claim',
              style: GoogleFonts.poppins(),
            ),
            content: SingleChildScrollView(
              child: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Container(
                              width: MediaQuery.of(context).size.width,
                              child: TextField(
                                onTap: () => _selectDateSurvey(context),
                                readOnly: true,
                                controller: _tanggalSurvey,
                                style: GoogleFonts.poppins(),
                                decoration: InputDecoration(
                                  labelText: "Tanggal Pengajuan",
                                  labelStyle: TextStyle(
                                    color: Color(0xFF70747F),
                                  ),
                                  hintText: "Tanggal Pengajuan",
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
                                style: GoogleFonts.poppins(),
                                decoration: InputDecoration(
                                  labelText: "No. DO",
                                  labelStyle: TextStyle(
                                    color: Color(0xFF70747F),
                                  ),
                                  hintText: "No. DO",
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
                                // expands: true,

                                style: GoogleFonts.poppins(),
                                decoration: InputDecoration(
                                  labelText: "No. PO",
                                  labelStyle: TextStyle(
                                    color: Color(0xFF70747F),
                                  ),
                                  hintText: "No. PO",
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
                                onTap: () => {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Column(
                                          children: [
                                            ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                controller: _scrollController,
                                                shrinkWrap: true,
                                                itemCount: dataCustomer.length,
                                                physics: ScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    leading: new Icon(Icons
                                                        .check_circle_outline),
                                                    title: new Text(
                                                        dataCustomer[index][1]),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      // setState(() {
                                                      //   _activities.text =
                                                      //       "${dataList[index][1]}";
                                                      // });
                                                    },
                                                  );
                                                }),
                                          ],
                                        );
                                      })
                                },
                                style: GoogleFonts.poppins(),
                                decoration: InputDecoration(
                                  labelText: "Customer",
                                  labelStyle: TextStyle(
                                    color: Color(0xFF70747F),
                                  ),
                                  hintText: "Customer",
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
                                // expands: true,

                                style: GoogleFonts.poppins(),
                                decoration: InputDecoration(
                                  labelText: "Barang",
                                  labelStyle: TextStyle(
                                    color: Color(0xFF70747F),
                                  ),
                                  hintText: "Barang",
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
                                //expands: true,
                                maxLines: 2,
                                minLines: 2,
                                style: GoogleFonts.poppins(),
                                decoration: InputDecoration(
                                  labelText: "Kondisi Barang",
                                  labelStyle: TextStyle(
                                    color: Color(0xFF70747F),
                                  ),
                                  hintText: "Kondisi Barang",
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      "Upload Foto Barang",
                                      style: TextStyle(
                                        color: Color(0xFF70747F),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ),
                                  FutureBuilder<File>(
                                    future: file,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<File> snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          null != snapshot.data) {
                                        tmpFile = snapshot.data;
                                        base64Image = base64Encode(
                                            snapshot.data.readAsBytesSync());
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 150,
                                          child: Image.file(
                                            snapshot.data,
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      } else if (null != snapshot.error) {
                                        return const Text(
                                          'Error Picking Image',
                                          textAlign: TextAlign.center,
                                        );
                                      } else {
                                        return const Text(
                                          'No Image Selected',
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 5.0,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            chooseImages();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFC9CFDF),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Ambil Gambar",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      height: 2,
                                      child: Container(
                                        color: Color(0xFFC9CFDF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                        top: 0),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF306bdd),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.save,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Text(
                                              "Submit",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF306bdd),
        title: Text(
          "Back",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FormPengajuan()));
        },
        icon: Icon(Icons.touch_app),
        label: Text("Pengajuan Claim"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 2,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: new ListTile(
                leading: new Icon(
                  Icons.search,
                ),
                title: TextField(
                  style: GoogleFonts.poppins(),
                  controller: controllerSearch,
                  decoration: new InputDecoration(
                    hintText: 'Search',
                    hintStyle: GoogleFonts.poppins(),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      filter = controllerSearch.text;
                      getTask(filter);
                    });
                    if (value == "") {
                      setState(() {
                        controllerSearchValue = false;
                      });
                    } else {
                      setState(() {
                        controllerSearchValue = true;
                      });
                    }
                  },
                ),
                trailing: new IconButton(
                  icon: new Icon(
                    Icons.cancel,
                    color: controllerSearchValue == true
                        ? Colors.blueGrey
                        : Colors.transparent,
                  ),
                  onPressed: () {
                    controllerSearch.clear();
                    setState(() {
                      controllerSearchValue = false;
                    });
                    setState(() {
                      getTask("");
                    });
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/notfound.gif",
                      fit: BoxFit.contain,
                      width: 250,
                    ),
                    Text(
                      "Data tidak ditemukan",
                      style: GoogleFonts.poppins(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
