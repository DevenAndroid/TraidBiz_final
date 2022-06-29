import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class Terms_and_conditions_drawer extends StatefulWidget {
  @override
  _Terms_and_conditions_drawerState createState() =>
      _Terms_and_conditions_drawerState();
}

class _Terms_and_conditions_drawerState
    extends State<Terms_and_conditions_drawer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://traidbiz.com/term-conditions/',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
