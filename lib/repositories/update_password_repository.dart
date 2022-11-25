import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:traidbiz/models/ModelResponseCommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../routers/my_router.dart';
import 'package:get/get.dart';
import '../utils/ApiConstant.dart';

Future<ModelResponseCommon> updatePassword(
    email, newPassword, confirmPassword, BuildContext context) async {
  var map = <String, dynamic>{};
  EasyLoading.show();

  map["email"] = email;
  map["new_password"] = newPassword;
  map["confirm_password"] = confirmPassword;
  http.Response response = await http.post(Uri.parse(ApiUrls.updatePasswordUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    EasyLoading.dismiss();

    return ModelResponseCommon.fromJson(json.decode(response.body));
  } else {
    EasyLoading.dismiss();

    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    throw Exception(response.body);
  }
}
