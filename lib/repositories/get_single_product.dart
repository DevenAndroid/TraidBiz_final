import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/Helpers.dart';
import '../models/ModelLogIn.dart';
import '../models/ModelSingleProduct.dart';
import '../utils/ApiConstant.dart';

Future<ModelSingleProductData> getSingleProductData( productId ) async {


  var map = <String, dynamic>{};
  SharedPreferences pref = await SharedPreferences.getInstance();
  if(pref.getString('user')!=null){
    ModelLogInData? user = ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
    map['cookie'] = user.cookie;
    print(':::::NormalCookie::::::'+user.cookie.toString());
  }
  else{
    map['cookie'] = pref.getString('deviceId');
    print(':::::DeviceIdCookie::::::'+pref.getString('deviceId').toString());
  }

  map['product_id'] = productId;

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  // OverlayEntry loader = Helpers.overlayLoader(context);
  // Overlay.of(context)!.insert(loader);

  http.Response response = await http.post(Uri.parse(ApiUrls.getSingleProductUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    // Helpers.hideLoader(loader);
    print("<<<<<<<getSingleProductData from repository=======>"+response.body.toString());
    return ModelSingleProductData.fromJson(json.decode(response.body));
  } else {
    // Helpers.hideLoader(loader);
    //Helpers.createSnackBar(context, response.statusCode.toString());
    throw Exception(response.body);
  }
}