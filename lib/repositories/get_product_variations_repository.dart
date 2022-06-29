import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/Helpers.dart';
import '../models/ModelGetProductVariation.dart';
import '../models/ModelLogIn.dart';
import '../utils/ApiConstant.dart';

Future<ModelGetProductVariationData> getProductVariationsData(BuildContext context, productId ) async {

  SharedPreferences pref = await SharedPreferences.getInstance();
  ModelLogInData? user = ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
  var map = <String, dynamic>{};
  map['product_id'] = productId;

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  // OverlayEntry loader = Helpers.overlayLoader(context);
  // Overlay.of(context)!.insert(loader);

  http.Response response = await http.post(Uri.parse(ApiUrls.getProductVariationUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    // Helpers.hideLoader(loader);
    print("<<<<<<<getSingleProductData from repository=======>"+response.body.toString());
    return ModelGetProductVariationData.fromJson(json.decode(response.body));
  } else {
    // Helpers.hideLoader(loader);
    Helpers.createSnackBar(context, response.statusCode.toString());
    throw Exception(response.body);
  }
}