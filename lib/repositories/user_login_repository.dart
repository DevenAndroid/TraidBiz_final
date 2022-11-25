import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/Helpers.dart';
import '../models/ModelLogIn.dart';

import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<ModelLogIn> createLogin(String username, String password,
    String deviceId, String fcmToken, BuildContext context) async {
  EasyLoading.show();
  var map = <String, dynamic>{};
  SharedPreferences pref = await SharedPreferences.getInstance();
  // pref.getString('fcmToken');

  map['username'] = username;
  map['password'] = password;
  map['device_id'] = pref.getString('deviceId');
  map['fcm_token'] = fcmToken;

  // OverlayEntry loader = Helpers.overlayLoader(context);
  // Overlay.of(context)!.insert(loader);

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Response response = await http.post(
      Uri.parse(
          "https://traidbiz.com/wp-json/api/woocustomer/generate_auth_cookie"),
      body: jsonEncode(map),
      headers: headers);

  if (response.statusCode == 200) {
    EasyLoading.dismiss();

    // Helpers.hideLoader(loader);
    return ModelLogIn.fromJson(json.decode(response.body));
  } else {
    EasyLoading.dismiss();

    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    Helpers.createSnackBar(context, response.body.toString());
    // Helpers.hideLoader(loader);
    throw Exception(response.body);
  }
}
