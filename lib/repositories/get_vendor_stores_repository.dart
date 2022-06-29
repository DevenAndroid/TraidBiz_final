import 'dart:convert';
import 'dart:io';

import 'package:dinelah/models/ModelVendorStore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../utils/ApiConstant.dart';

Future<ModelVendorStores> getVendorStores(map) async {
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };
  http.Response response = await http.post(Uri.parse(ApiUrls.vendorStoresUrl),
      body: jsonEncode(map), headers: headers);

  debugPrint('REQUEST PARAMETER :: ${jsonEncode(map)}');
  debugPrint('REQUEST PARAMETER ::11 ${response.body}');
  if (response.statusCode == 200) {
    return ModelVendorStores.fromJson(json.decode(response.body));
  } else {
    throw Exception(response.body);
  }
}
