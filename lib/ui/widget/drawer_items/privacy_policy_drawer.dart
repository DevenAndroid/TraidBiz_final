import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class PrivacyPolicyScreenDrawer extends StatefulWidget {
  @override
  _PrivacyPolicyScreenDrawerState createState() =>
      _PrivacyPolicyScreenDrawerState();
}

class _PrivacyPolicyScreenDrawerState extends State<PrivacyPolicyScreenDrawer> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://traidbiz.com/privacy-policy/',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
