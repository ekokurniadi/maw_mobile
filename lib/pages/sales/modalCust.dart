import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../config.dart';
import 'package:http/http.dart' as http;

class ModalCustomer extends StatefulWidget {
  @override
  _ModalCustomerState createState() => _ModalCustomerState();
}

class _ModalCustomerState extends State<ModalCustomer> {
  ScrollController _scrollController = new ScrollController();
  final TextEditingController textController = new TextEditingController();
  final TextEditingController controllerSearch = TextEditingController();
  bool controllerSearchValue = true;
  String filter = "";
  int page = 20;
  bool isLoading = false;
  List<dynamic> dataCustomer;
  getMoreData(int index, String filter) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var url = await http.post(Config.BASE_URL + "fetch_data", body: {
        "start": "0",
        "length": index.toString(),
        "draw": "1",
        "searching": "$filter",
      });
      // final response = jsonDecode(url.body);
      Map<String, dynamic> response = jsonDecode(url.body);

      print("$index");
      setState(() {
        dataCustomer = response["data"];
        isLoading = false;
        page++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controllerSearchValue = false;
    getMoreData(page, filter);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData(page, filter);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 25, left: 8, right: 8, bottom: 8),
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
                    autofocus: true,
                    style: GoogleFonts.poppins(),
                    controller: controllerSearch,
                    decoration: new InputDecoration(
                      hintText: 'Pencarian Customer',
                      hintStyle: GoogleFonts.poppins(),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        filter = controllerSearch.text;
                        getMoreData(page, filter);
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
                        getMoreData(page, "");
                      });
                    },
                  ),
                ),
              ),
              dataCustomer == null
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.80,
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: dataCustomer.length == null
                              ? 0
                              : dataCustomer.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == dataCustomer.length ||
                                dataCustomer.length == null) {
                              return _buildProgressIndicator();
                            } else {
                              return ListTile(
                                leading: new Icon(Icons.trip_origin),
                                title:
                                    new Text(dataCustomer[index][3].toString()),
                                onTap: () {
                                  Navigator.pop(context,
                                      dataCustomer[index][3].toString());
                                  // setState(() {
                                  //   _activities.text =
                                  //       "${dataList[index][1]}";
                                  // });
                                },
                              );
                            }
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
