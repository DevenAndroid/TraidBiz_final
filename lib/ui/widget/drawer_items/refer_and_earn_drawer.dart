import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class ReferAndEarnDrawer extends StatefulWidget {
  @override
  _ReferAndEarnDrawerState createState() => _ReferAndEarnDrawerState();
}

class _ReferAndEarnDrawerState extends State<ReferAndEarnDrawer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://traidbiz.com/why-traidbiz/',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
