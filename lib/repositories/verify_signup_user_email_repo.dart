import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ModelLogIn.dart';
import '../models/ModelSingleProduct.dart';
import '../models/verify_signup_user_email_model.dart';
import '../utils/ApiConstant.dart';
import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<SignUpUserEmailVerifyModel> verifySignupUserEmail(email, otp) async {
  var map = <String, dynamic>{};
  map['email'] = email;
  map['otp'] = otp;
  EasyLoading.show();
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Response response = await http.post(
      Uri.parse(ApiUrls.verifySignUpUserEmail),
      body: jsonEncode(map),
      headers: headers);
  print(
      "${jsonEncode(map).toString()}RESPONSE FORM MAP OF VERIFY SIGN UP SCREEN");

  if (response.statusCode == 200) {
    EasyLoading.dismiss();

    print("${response.body.toString()}RESpense form signup api");
    return SignUpUserEmailVerifyModel.fromJson(json.decode(response.body));
  } else {
    EasyLoading.dismiss();

    print("${response.body.toString()}RESponse form signup api not found");

    Get.offAndToNamed(MyRouter.signUpScreen,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    throw Exception(response.body);
  }
}
