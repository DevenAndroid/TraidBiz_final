import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/Helpers.dart';
import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';

Future<ModelLogIn> createLogin(String username, String password,
    String deviceId, String fcmToken, BuildContext context) async {
  var map = <String, dynamic>{};
  SharedPreferences pref = await SharedPreferences.getInstance();
  // pref.getString('fcmToken');

  map['username'] = username;
  map['password'] = password;
  map['device_id'] = pref.getString('deviceId');
  map['fcm_token'] = fcmToken;

  OverlayEntry loader = Helpers.overlayLoader(context);
  Overlay.of(context)!.insert(loader);

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  print('REQUEST PARAM ::' + jsonEncode(map));
  http.Response response = await http.post(
      Uri.parse(
          "https://newtraidbiz.eoxysitsolution.com/wp-json/api/woocustomer/generate_auth_cookie"),
      body: jsonEncode(map),
      headers: headers);

  if (response.statusCode == 200) {
    Helpers.hideLoader(loader);
    return ModelLogIn.fromJson(json.decode(response.body));
  } else {
    Helpers.createSnackBar(context, response.body.toString());
    Helpers.hideLoader(loader);
    throw Exception(response.body);
  }
}
