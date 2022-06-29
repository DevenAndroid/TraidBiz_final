import 'package:dinelah/controller/GetHomeController.dart';
import 'package:dinelah/controller/SplashScreenController.dart';
import 'package:dinelah/res/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final splashScreen = Get.put(SplashScreenController());

  final _controller = Get.put(GetHomeController());
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image.asset(
            AppAssets.splashBg,
            width: screenSize.width,
            height: MediaQuery.of(context).size.height * 0.75,
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: 0,
            child: Image.asset(
              AppAssets.logoWelcome,
              width: screenSize.width * 0.7,
            ),
          ),
        ],
      ),
    );
  }
}
