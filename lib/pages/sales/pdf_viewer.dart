import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config.dart' as conn;

// ignore: must_be_immutable
class PdfViewer extends StatefulWidget {
  String id;
  PdfViewer({this.id});
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool _isLoading = true;
  PDFDocument document;
  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(
        conn.Config.BASE_URL_IMAGE + "image/" + widget.id);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id,
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Center(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : PDFViewer(
                  document: document,
                  lazyLoad: true,
                  enableSwipeNavigation: true,
                  scrollDirection: Axis.horizontal,
                )),
    );
  }
}
