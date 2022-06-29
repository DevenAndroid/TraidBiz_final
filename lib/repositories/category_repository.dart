import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/Helpers.dart';
import '../models/ModelCategoryData.dart';
import '../models/ModelCategoryProducts.dart';
import '../models/ModelLogIn.dart';
import '../models/ModelSingleProduct.dart';
import '../utils/ApiConstant.dart';

Future<ModelCategoryData> getCategoryData( ) async {
  bool isDataLoading =true;
  SharedPreferences pref = await SharedPreferences.getInstance();
  var map = <String, dynamic>{};
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  // OverlayEntry loader = Helpers.overlayLoader(context);
  // Overlay.of(context)!.insert(loader);

  http.Response response = await http.post(Uri.parse(ApiUrls.getCategoryUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {

    // Helpers.hideLoader(loader);
    print("<<<<<<<getCategoryProduct from repository=======>"+response.body.toString());
    return ModelCategoryData.fromJson(json.decode(response.body));
  } else {
    // Helpers.hideLoader(loader);
    //Helpers.createSnackBar(context, response.statusCode.toString());
    throw Exception(response.body);
  }
}