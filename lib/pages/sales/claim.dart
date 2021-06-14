import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
class Claim extends StatefulWidget {
  @override
  _ClaimState createState() => _ClaimState();
}

class _ClaimState extends State<Claim> {
  final TextEditingController controllerSearch = TextEditingController();
    TextEditingController _tanggalSurvey = TextEditingController();
  bool controllerSearchValue = true;
  List<dynamic> dataList;
  String filter = "";
   DateTime selectedDateSurvey = DateTime.now();
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

  @override
  void initState() {
    super.initState();
    getTask("");
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
    // print(selectedDateMeter);
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
              child: Column(
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
                             height: MediaQuery.of(context).size.height * 0.20,
                             child: Image.asset("images/no-image.png"),
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
                                      left: 10, right: 10, bottom: 10, top: 0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF306bdd),
                                    borderRadius: BorderRadius.circular(20),
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
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
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
          myAlertCancel();
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
