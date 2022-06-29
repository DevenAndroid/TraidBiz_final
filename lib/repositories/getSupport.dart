import 'dart:convert';
import 'dart:io';

import 'package:dinelah/models/ModelResponseCommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/Helpers.dart';
import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';

Future<ModelResponseCommon> getSupport(
    BuildContext context, storeId, subject, message) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  //https://dinelah.eoxysitsolution.com/wp-json/api/woocustomer/get_support
  //
  // Parameters:-
  //
  // {
  // 	"cookie":"eoxystestidone|1653396011|fEWgNhg1mMtMcDnCAW5FOrXlnDfH8q2Iyzd2qsF6IjA|1a6c9d0a979a4063b7adbcc3943e11f0a32f1f0af8b236433d882d424e0eaea1",
  // 	"store_id":"39",
  // 	"subject":"API test",
  //         "order_id":"5969",
  // 	"message":"APIs support testing....."
  // }
  var map = <String, dynamic>{};
  if (pref.getString('user') != null) {
    ModelLogInData? user =
        ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
    map['cookie'] = user.cookie;
  } else {
    map['cookie'] = pref.getString('deviceId');
  }
  map['store_id'] = storeId;
  map['subject'] = subject;
  map['message'] = message;

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  OverlayEntry loader = Helpers.overlayLoader(context);
  Overlay.of(context)!.insert(loader);

  http.Response response = await http.post(Uri.parse(ApiUrls.getSupportUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    Helpers.hideLoader(loader);
    return ModelResponseCommon.fromJson(json.decode(response.body));
  } else {
    Helpers.hideLoader(loader);
    Helpers.createSnackBar(context, response.statusCode.toString());
    throw Exception(response.body);
  }
}
