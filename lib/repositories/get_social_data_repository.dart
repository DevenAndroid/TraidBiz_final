import 'dart:convert';
import 'dart:io';

import 'package:traidbiz/models/ModelSocialResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../helper/Helpers.dart';
import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';

Future<ModelSocialResponse> getSocialLogin(
    BuildContext context, socialLoginId, socialType) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  //ModelLogInData? user = ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
  var map = <String, dynamic>{};
  map['social_login_id'] = socialLoginId;
  map['social_type'] = socialType;
  if (pref.getString('user') != null) {
    ModelLogInData? user = ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
    map['device_id'] = user.cookie;
    print("CATEGORY SCREEN COOKIES " + user.cookie.toString());
  } else {
    map['device_id'] = pref.getString('deviceId');
  }

  print("::::::idToken:::::::=>$socialLoginId");
  print("::::::getSocialLogin Map:::::::=>$map");
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Response response = await http.post(Uri.parse(ApiUrls.socialApiUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    print("<<<<<<<GetSocialData from repository=======>${response.body}");
    return ModelSocialResponse.fromJson(json.decode(response.body));
  } else {
    Helpers.createSnackBar(context, response.statusCode.toString());
    throw Exception(response.body);
  }
}
