import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ModelCategoryData.dart';

import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';
import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<ModelCategoryData> getCategoryData() async {
  bool isDataLoading = true;
  SharedPreferences pref = await SharedPreferences.getInstance();

  var map = <String, dynamic>{};
  if (pref.getString('user') != null) {
    ModelLogInData? user =
        ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
    map['cookie'] = user.cookie;
    print("CATEGORY SCREEN COOKIES " + user.cookie.toString());
  } else {
    map['cookie'] = pref.getString('deviceId');
  }
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Response response = await http.post(Uri.parse(ApiUrls.getCategoryUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    // Helpers.hideLoader(loader);
    print("<<<<<<<getCategoryProduct from repository=======>" +
        response.body.toString());
    return ModelCategoryData.fromJson(json.decode(response.body));
  } else {
    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    throw Exception(response.body);
  }
}
