import 'dart:convert';

import 'package:traidbiz/models/model_verify_otp_forgot_password.dart';
import 'package:traidbiz/utils/ApiConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<ModelVerifyOTPForgotPassword> verifyOTPPassword(
    userEmail, otp, BuildContext context) async {
  var map = <String, dynamic>{};
  map["user_login"] = userEmail;
  map["otp"] = otp;

  http.Response response = await http.post(
      Uri.parse(ApiUrls.forgotPasswordOTPVerifyUrl),
      body: jsonEncode(map),
      headers: headers);
  if (response.statusCode == 200) {
    return ModelVerifyOTPForgotPassword.fromJson(json.decode(response.body));
  } else {
    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    throw Exception(response.body);
  }
}
