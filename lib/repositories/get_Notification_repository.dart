import 'dart:convert';
import 'dart:io';

import 'package:dinelah/models/ModelNotification.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';

Future<ModelNotificationData> getNotificationData() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  ModelLogInData? user =
      ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
  var map = <String, dynamic>{};
  map['cookie'] = user.cookie;
  print(':::::::::::' + user.cookie.toString());

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  // OverlayEntry loader = Helpers.overlayLoader(context);
  // Overlay.of(context)!.insert(loader);

  http.Response response = await http.post(
      Uri.parse(ApiUrls.getNotificationUrl),
      body: jsonEncode(map),
      headers: headers);

  if (response.statusCode == 200) {
    //Helpers.hideLoader(loader);
    print("<<<<<<<getNotificationUrl from repository=======>" +
        response.body.toString());
    return ModelNotificationData.fromJson(json.decode(response.body));
  } else {
    //Helpers.hideLoader(loader);
    // Helpers.createSnackBar(context, response.statusCode.toString());
    throw Exception(response.body);
  }
}
