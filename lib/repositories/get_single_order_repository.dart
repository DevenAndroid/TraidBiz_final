import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ModelLogIn.dart';
import '../models/ModelSingleOrder.dart';
import '../utils/ApiConstant.dart';
import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<ModelSingleOrderData> getSingleOrderData(orderId) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  ModelLogInData? user =
      ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
  var map = <String, dynamic>{};
  map['cookie'] = user.cookie;
  map['order_id'] = orderId;
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

  // OverlayEntry loader = Helpers.overlayLoader(context);
  // Overlay.of(context)!.insert(loader);

  http.Response response = await http.post(Uri.parse(ApiUrls.getSingleOrderUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    return ModelSingleOrderData.fromJson(json.decode(response.body));
  } else {
    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    throw Exception(response.body);
  }
}
