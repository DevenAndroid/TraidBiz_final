import 'dart:developer';

import 'package:client_information/client_information.dart';
import 'package:dinelah/routers/my_router.dart';
import 'package:dinelah/ui/screens/all_hosts.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _getClientInformation();
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      Get.offAndToNamed(MyRouter.customBottomBar);
      // Get.to(AllHostsScreen());
      // Get.offAndToNamed(MyRouter.logInScreen);
    });
  }

  Future<void> _getClientInformation() async {
    ClientInformation? info;
    try {
      info = await ClientInformation.fetch();
    } on PlatformException {
      log('Failed to get client information');
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceId', info!.deviceId.toString());
  }
}
