import 'dart:convert';

import 'package:dinelah/helper/Helpers.dart';
import 'package:dinelah/models/ModelResponseCommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../utils/ApiConstant.dart';

Future<ModelResponseCommon> resendOtp(email, context) async {
  var map = <String, dynamic>{};
  map["email"] = email;

  OverlayEntry loader = Helpers.overlayLoader(context);
  Overlay.of(context)!.insert(loader);
  http.Response response = await http.post(Uri.parse(ApiUrls.resendOtp),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    Helpers.hideLoader(loader);
    return ModelResponseCommon.fromJson(json.decode(response.body));
  } else {
    Helpers.createSnackBar(context, response.statusCode.toString());
    Helpers.hideLoader(loader);
    throw Exception(response.body);
  }
}
