import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maw/pages/sales/customerDatabase.dart';
import 'package:maw/pages/sales/katalog.dart';
import 'package:maw/pages/sales/price_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesTools extends StatefulWidget {
  @override
  _SalesToolsState createState() => _SalesToolsState();
}

class _SalesToolsState extends State<SalesTools> {
  String nama = "";
  Image image1;
  Image image2;
  Image image3;
  Image image4;
  Image image5;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    image1 = Image.asset(
      "images/katalog.jpg",
      fit: BoxFit.contain,
    );
    image2 = Image.asset(
      "images/price-list.jpg",
      fit: BoxFit.contain,
    );
    image3 = Image.asset(
      "images/prospek.jpg",
      fit: BoxFit.contain,
    );
    image4 = Image.asset(
      "images/jadwal.jpg",
      fit: BoxFit.contain,
    );
    image5 = Image.asset(
      "images/customer-data.jpg",
      fit: BoxFit.contain,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
    precacheImage(image4.image, context);
    precacheImage(image5.image, context);
  }

  getCurrentUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idUser = preferences.getString("nama");
    setState(() {
      nama = idUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF306bdd),
        title: Text(
          "Back to Home",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      backgroundColor: Color(0xFFf4f4f4),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF306bdd),
                  Color(0xFF306bdd),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.transparent,
                      ),
                      child: Image.asset(
                        "images/sales-tools.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: Text("Sales Tools",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Container(
                child: Text("Explore Menu",
                    style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        color: Color(0xFF2c406e),
                        fontWeight: FontWeight.w500)),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Katalog())),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width / 2.2,
                      height: MediaQuery.of(context).size.height * 0.20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(width: 80, height: 80, child: image1),
                                Container(
                                  child: Text(
                                    "Katalog Produk",
                                    style: GoogleFonts.poppins(
                                        color: Color(0xFF2c406e),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=> Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PriceList())),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width / 2.2,
                      height: MediaQuery.of(context).size.height * 0.20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(width: 80, height: 80, child: image2),
                                Container(
                                  child: Text(
                                    "Price List",
                                    style: GoogleFonts.poppins(
                                        color: Color(0xFF2c406e),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // pindah
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: MediaQuery.of(context).size.height * 0.20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 2,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(width: 80, height: 80, child: image3),
                              Container(
                                child: Text(
                                  "Prospek",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xFF2c406e),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: MediaQuery.of(context).size.height * 0.20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 2,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(width: 80, height: 80, child: image4),
                              Container(
                                child: Text(
                                  "Jadwal",
                                  style: GoogleFonts.poppins(
                                      color: Color(0xFF2c406e),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // pindah
            // pindah
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerDatabase())),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width / 2.2,
                      height: MediaQuery.of(context).size.height * 0.20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 2,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(width: 80, height: 80, child: image5),
                                Container(
                                  child: Text(
                                    "Data Konsumen",
                                    style: GoogleFonts.poppins(
                                        color: Color(0xFF2c406e),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // pindah
            Container(height: MediaQuery.of(context).size.height * 0.20)
          ],
        ),
      ),
    );
  }
}
