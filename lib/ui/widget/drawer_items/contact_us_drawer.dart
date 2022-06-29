import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class ContactUsScreenDrawer extends StatefulWidget {
  @override
  _ContactUsScreenDrawerState createState() => _ContactUsScreenDrawerState();
}

class _ContactUsScreenDrawerState extends State<ContactUsScreenDrawer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://traidbiz.com/contact-us/',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
