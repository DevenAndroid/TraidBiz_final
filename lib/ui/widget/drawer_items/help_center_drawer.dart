import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class HelpCenterScreenDrawer extends StatefulWidget {
  @override
  _HelpCenterScreenDrawerState createState() => _HelpCenterScreenDrawerState();
}

class _HelpCenterScreenDrawerState extends State<HelpCenterScreenDrawer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://traidbiz.com/help-centre/',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
