import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:traidbiz/models/ModelGetSocialLinks.dart';
import 'package:traidbiz/models/ModelResponseCommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';
import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<ModelGetSocialLinksResponse> getSocialLinksData() async {

  var map = <String, dynamic>{};
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Response response = await http.post(Uri.parse(ApiUrls.getSocialLinksUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {

    print("<<<<<<<getSocialLinksUrl from repository=======>${response.body}");
    return ModelGetSocialLinksResponse.fromJson(json.decode(response.body));
  } else {


    throw Exception(response.body);
  }
}
