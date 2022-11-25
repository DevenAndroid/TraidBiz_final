import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/Helpers.dart';
import '../models/ModelResponseCommon.dart';
import '../routers/my_router.dart';
import '../utils/ApiConstant.dart';

Future<ModelResponseCommon> register(email, countryCode, countryIsoCode, mobileNumber, password,
    String socialLoginId, socialType, BuildContext context) async {
  var map = <String, dynamic>{};
  SharedPreferences pref = await SharedPreferences.getInstance();
  map['email'] = email;
  map['country_code'] = countryCode;
  map['country_iso_code'] = countryIsoCode;
  map['phone'] = mobileNumber;
  map['password'] = password;
  if (socialType == 'google') {
    map['social_login_id'] = pref.getString('socialLoginId');
  } else {
    map['social_login_id'] = pref.getString('fbLoginId');
  }
  map['social_type'] = socialType;

  OverlayEntry loader = Helpers.overlayLoader(context);
  Overlay.of(context)!.insert(loader);

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  print('REQUEST PARAM :: ' + map.toString());

  http.Response response = await http.post(Uri.parse(ApiUrls.registerUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    Helpers.hideLoader(loader);
    return ModelResponseCommon.fromJson(json.decode(response.body));
  } else {
    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    Helpers.hideLoader(loader);
    Helpers.createSnackBar(context, response.statusCode.toString());
    throw Exception(response.body);
  }
}
