import 'dart:convert';
import 'dart:io';

import 'package:dinelah/models/ModelSocialResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../helper/Helpers.dart';
import '../models/ModelGetOrder.dart';
import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';

Future<ModelSocialResponse> getSocialLogin(BuildContext context,socialLoginId, socialType) async {

  SharedPreferences pref = await SharedPreferences.getInstance();
  //ModelLogInData? user = ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
  var map = <String, dynamic>{};
  map['social_login_id'] = socialLoginId;
  map['social_type'] = socialType;

  print("::::::idToken:::::::=>"+socialLoginId.toString());
  print("::::::getSocialLogin Map:::::::=>"+map.toString());
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Response response = await http.post(Uri.parse(ApiUrls.socialApiUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {

    print("<<<<<<<GetSocialData from repository=======>"+response.body.toString());
    return ModelSocialResponse.fromJson(json.decode(response.body));
  } else {
    Helpers.createSnackBar(context, response.statusCode.toString());
    throw Exception(response.body);
  }
}