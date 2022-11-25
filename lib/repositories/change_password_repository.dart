import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:traidbiz/models/ModelResponseCommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';
import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<ModelResponseCommon> getChangePassword(
    BuildContext context, oldPassword, newPassword) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  ModelLogInData? user =
      ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
  var map = <String, dynamic>{};
  EasyLoading.show();
  map['cookie'] = user.cookie;
  map['old_password'] = oldPassword;
  map['new_password'] = newPassword;
  print(':::::::::::' + user.cookie.toString());

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Response response = await http.post(Uri.parse(ApiUrls.changePasswordUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    EasyLoading.dismiss();

    print("<<<<<<<getChangePassword from repository=======>" +
        response.body.toString());
    return ModelResponseCommon.fromJson(json.decode(response.body));
  } else {
    EasyLoading.dismiss();

    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    throw Exception(response.body);
  }
}
