import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config.dart';

class DoTracking extends StatefulWidget {
  @override
  _DoTrackingState createState() => _DoTrackingState();
}

class _DoTrackingState extends State<DoTracking> {
  double progress = 0;
  InAppWebViewController webView;
  Widget _buildProgressBar() {
    if (progress != 1.0) {
      return Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
            backgroundColor: Colors.white,
          ),
          Container(
            child: Center(
              child: Text(""),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf4f4f4),
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
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                if (webView != null) {
                  webView.reload();
                }
              })
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: InAppWebView(
                      initialUrl: Config.BASE_URL_WEB + "do_tracking/index_mobile",
                      onWebViewCreated: (InAppWebViewController controller) {
                        webView = controller;
                      },
                      onLoadStart:
                          (InAppWebViewController controller, String url) {},
                      onLoadStop: (InAppWebViewController controller,
                          String url) async {},
                      onProgressChanged:
                          (InAppWebViewController controller, int progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onReceivedServerTrustAuthRequest:
                          (controller, challenge) async {
                        print(challenge);
                        return ServerTrustAuthResponse(
                            action: ServerTrustAuthResponseAction.PROCEED);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: _buildProgressBar(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
