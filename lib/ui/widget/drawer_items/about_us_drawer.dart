import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class AboutUsScreenDrawer extends StatefulWidget {
  @override
  _AboutUsScreenDrawerState createState() => _AboutUsScreenDrawerState();
}

class _AboutUsScreenDrawerState extends State<AboutUsScreenDrawer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://traidbiz.com/about-us/',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
