import 'dart:convert';

import 'package:traidbiz/helper/Helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/ModelVerifySignUpEmail.dart';
import '../utils/ApiConstant.dart';
import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<VerifySignUpEmailOtpModel> resendVerifyEmailOtp(email, context) async {
  var map = <String, dynamic>{};
  map["email"] = email;

  // OverlayEntry loader = Helpers.overlayLoader(context);
  // Overlay.of(context)!.insert(loader);
  http.Response response = await http.post(
      Uri.parse(ApiUrls.resendVerifyEmailOtp),
      body: jsonEncode(map),
      headers: headers);

  if (response.statusCode == 200) {
    // Helpers.hideLoader(loader);
    return VerifySignUpEmailOtpModel.fromJson(json.decode(response.body));
  } else {
    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    // Helpers.createSnackBar(context, response.statusCode.toString());
    // Helpers.hideLoader(loader);
    throw Exception(response.body);
  }
}
