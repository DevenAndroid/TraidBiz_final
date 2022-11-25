import 'dart:convert';
import 'dart:io';

import 'package:traidbiz/models/ModelCartQuantity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';
import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<ModelCartQuantity> getCartCount() async {
  var map = <String, dynamic>{};
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.getString('user') != null) {
    ModelLogInData? user =
        ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
    map['cookie'] = user.cookie;
  } else {
    map['cookie'] = pref.getString('deviceId');
  }

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Response response = await http.post(Uri.parse(ApiUrls.getCartCountUrl),
      body: jsonEncode(map), headers: headers);

  print(response.body.toString() + "Lokesh sir api");
  if (response.statusCode == 200) {
    return ModelCartQuantity.fromJson(json.decode(response.body));
  } else {
    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    throw Exception(response.body);
  }
}
