import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:traidbiz/models/ModelLogIn.dart';
import '../models/ModelStoreInfo.dart';
import '../utils/ApiConstant.dart';
import '../routers/my_router.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<ModelStoreInfoData> getStoreInfo(storeId) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var map = <String, dynamic>{};
  if (pref.getString('user') != null) {
    ModelLogInData? user =
    ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
    map['cookie'] = user.cookie;
  } else {
    map['cookie'] = pref.getString('deviceId');
  }
  map['store_id'] = storeId;

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };
  http.Response response = await http.post(Uri.parse(ApiUrls.getStoreInfoUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    return ModelStoreInfoData.fromJson(json.decode(response.body));
  } else {
    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    throw Exception(response.body);
  }
}
