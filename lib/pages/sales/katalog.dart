import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:maw/pages/sales/pdf_viewer.dart';
import '../../config.dart';

class Katalog extends StatefulWidget {
  @override
  _KatalogState createState() => _KatalogState();
}

class _KatalogState extends State<Katalog> {
  final TextEditingController controllerSearch = TextEditingController();
  bool controllerSearchValue = true;
  List<dynamic> dataList;
  String filter = "";
  Future<String> getTask(String filter) async {
    final response = await http
        .post(Config.BASE_URL + "getKatalog", body: {"filter": filter});
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
          dataList == null
              ? Center(
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
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 2.0,
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: Card(
                        elevation: 2,
                        child: ClipPath(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: Text(
                                    "${dataList[index][1]}",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Divider(),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PdfViewer(
                                                id: dataList[index][2],
                                              ))),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                    ),
                                    margin: EdgeInsets.all(8.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text("Preview",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
        ],
      )),
    );
  }
}
