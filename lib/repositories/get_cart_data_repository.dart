import 'dart:convert';
import 'dart:io';

import 'package:dinelah/models/ModelLogIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../models/ModelGetCart.dart';
import '../utils/ApiConstant.dart';

Future<ModelGetCartData> getCartData() async {

   var map = <String, dynamic>{};
   SharedPreferences pref = await SharedPreferences.getInstance();

   if(pref.getString('user')!=null){
     ModelLogInData? user = ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
     map['cookie'] = user.cookie;
   }else{
     map['cookie']= pref.getString('deviceId');
     print(":::::Device Id::::"+ pref.getString('deviceId').toString());
   }


  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Response response = await http.post(Uri.parse(ApiUrls.getCartUrl),
      body: jsonEncode(map), headers: headers);

   // EasyLoading.show();
  if (response.statusCode == 200) {
    // EasyLoading.dismiss();

    print("<<<<<<<GetCartData from repository=======>"+response.body.toString());
    return ModelGetCartData.fromJson(json.decode(response.body));
  } else {
    // Helpers.createSnackBar(context, response.statusCode.toString());
    throw Exception(response.body);
  }
}