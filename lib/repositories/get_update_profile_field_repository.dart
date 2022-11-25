import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:traidbiz/models/ModelResponseCommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/Helpers.dart';
import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';
import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<ModelResponseCommon> getUpdateProfileFieldData(BuildContext context,
    firstName, lastName, countryIsoCode, countryCode, emailAddress, phoneNumber, profileImage) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  ModelLogInData? user = ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
  var map = <String, dynamic>{};
  map['cookie'] = user.cookie;
  map['first_name'] = firstName;
  map['last_name'] = lastName;
  map['email'] = emailAddress;
  map['country_iso_code'] = countryIsoCode;
  map['country_code'] = countryCode;
  map['phone'] = phoneNumber;
  map['profile_image'] = profileImage;

  log(map.toString());

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  OverlayEntry loader = Helpers.overlayLoader(context);
  Overlay.of(context)!.insert(loader);

  http.Response response = await http.post(
      Uri.parse(ApiUrls.updateProfileFieldUrl),
      body: jsonEncode(map),
      headers: headers);

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
