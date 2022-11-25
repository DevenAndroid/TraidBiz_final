import 'dart:convert';

import 'package:traidbiz/controller/BottomNavController.dart';
import 'package:traidbiz/models/ModelLogIn.dart';
import 'package:traidbiz/routers/my_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../res/app_assets.dart';
import '../../res/theme/theme.dart';
import '../widget/common_widget.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  final bottomNavController = Get.put(BottomNavController());
  var cookie;

  RxBool isDataLoad = false.obs;

  getLoadPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ModelLogInData? user =
        ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));

    setState(() {
      cookie = user.cookie;
    });
  }

  @override
  void initState() {
    super.initState();
    getLoadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    String webUrl =
        "${"https://traidbiz.com/checkout/?cookie=" + cookie}&appchekout=yes";
    print("::::::::::::::::::::::::: cookie from check out page is $webUrl");
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xfffff8f9),
        image: DecorationImage(
          image: AssetImage(
            AppAssets.cartShapeBg,
          ),
          alignment: Alignment.topRight,
          fit: BoxFit.contain,
        ),
      ),
      child: Scaffold(
        appBar: backAppBar("Checkout"),
        backgroundColor: Colors.transparent,
        body: WillPopScope(
          onWillPop: () async {
            bottomNavController.getData();
            return true;
          },
          child: Stack(
            children: [
              WebView(
                initialUrl: webUrl.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (String url) {
                  setState(() {
                    isDataLoad.value = true;
                  });
                },
                navigationDelegate: (action) {
                  print('ACTION :: ' + action.url.toString());
                  bottomNavController.getData();
                  if (action.url.contains('key=')) {
                    bottomNavController.getData();
                  }
                  if (!action.url.contains('checkout')) {
                    Get.offAllNamed(MyRouter.customBottomBar);
                    return NavigationDecision.prevent;
                  } else {
                    return NavigationDecision.navigate;
                  }
                },
              ),
              !isDataLoad.value
                  ? const Center(
                      child: CupertinoActivityIndicator(
                          animating: true,
                          color: AppTheme.primaryColor,
                          radius: 30))
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
