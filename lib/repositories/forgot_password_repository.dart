import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/Helpers.dart';
import '../models/ModelResponseCommon.dart';
import '../utils/ApiConstant.dart';

Future<ModelResponseCommon> forgotPassword(
    String username, BuildContext context) async {
  var map = <String, dynamic>{};
  map['user_login'] = username;

  print("::::::::::username forgot password:::::::::::" + username.toString());

  OverlayEntry loader = Helpers.overlayLoader(context);
  Overlay.of(context)!.insert(loader);

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Response response = await http.post(Uri.parse(ApiUrls.forgotPasswordUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    Helpers.hideLoader(loader);
    print("::::::::::username forgot password:::::::::::" +
        response.body.toString());
    return ModelResponseCommon.fromJson(json.decode(response.body));
  } else {
    // Helpers.createSnackBar(context, response.statusCode.toString());
    Helpers.hideLoader(loader);
    throw Exception(response.body);
  }
}
