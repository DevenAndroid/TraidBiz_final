import 'package:traidbiz/controller/GetHomeController.dart';
import 'package:traidbiz/controller/SplashScreenController.dart';
import 'package:traidbiz/res/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final splashScreen = Get.put(SplashScreenController());

  final _controller = Get.put(GetHomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
        children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Image.asset(
                AppAssets.logoWelcome,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
            Image.asset(
              AppAssets.splashBgNew,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
        ],
      ),
          )),
    );
  }
}
