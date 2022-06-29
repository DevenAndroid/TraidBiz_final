import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class ShippingPolicyScreen extends StatefulWidget {
  @override
  _ShippingPolicyScreenState createState() => _ShippingPolicyScreenState();
}

class _ShippingPolicyScreenState extends State<ShippingPolicyScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://traidbiz.com/shipping-policy/',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
