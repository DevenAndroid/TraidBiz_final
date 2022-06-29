import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../helper/Helpers.dart';
import '../models/ModelLogIn.dart';
import '../models/ModelStoreInfo.dart';
import '../utils/ApiConstant.dart';

Future<ModelStoreInfoData> getStoreInfo(storeId) async {
  var map = <String, dynamic>{};
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // if(pref.getString('user')!=null){
  //   ModelLogInData? user = ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
  //   map['cookie'] = user.cookie;
  //   print(":::::Normal cookie in store info::::::::"+user.cookie);
  // }else{
  //   map['cookie'] = pref.getString('deviceId');
  //   print(":::::store info deviceId cookie::::::::"+pref.getString('deviceId').toString());
  // }
  map['store_id'] = storeId;

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  // OverlayEntry loader = Helpers.overlayLoader(context);
  // Overlay.of(context)!.insert(loader);
  log("store info store_id::" + map.toString());
  http.Response response = await http.post(Uri.parse(ApiUrls.getStoreInfoUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    // Helpers.hideLoader(loader);
    log("<<<<<<<GetStoreInfoData from repository=======>" +
        response.body.toString());
    return ModelStoreInfoData.fromJson(json.decode(response.body));
  } else {
    // Helpers.hideLoader(loader);
    //Helpers.createSnackBar(context, response.statusCode.toString());
    throw Exception(response.body);
  }
}
