import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class SellOnTraidBizScreenDrawer extends StatefulWidget {
  @override
  _SellOnTraidBizScreenDrawerState createState() =>
      _SellOnTraidBizScreenDrawerState();
}

class _SellOnTraidBizScreenDrawerState
    extends State<SellOnTraidBizScreenDrawer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://traidbiz.com/vendor-membership/',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
