import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class PaymentsOptionsDrawerScreen extends StatefulWidget {
  @override
  _PaymentsOptionsDrawerScreenState createState() =>
      _PaymentsOptionsDrawerScreenState();
}

class _PaymentsOptionsDrawerScreenState
    extends State<PaymentsOptionsDrawerScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://traidbiz.com/payment-options/',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
