import 'dart:convert';
import 'dart:io';

import 'package:traidbiz/models/ModelVendorStore.dart';

import '../routers/my_router.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/ApiConstant.dart';

Future<ModelVendorStores> getVendorStores(map) async {
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };
  http.Response response = await http.post(Uri.parse(ApiUrls.vendorStoresUrl),
      body: jsonEncode(map), headers: headers);

  if (response.statusCode == 200) {
    print("search controller response" + response.body.toString());
    return ModelVendorStores.fromJson(json.decode(response.body));
  } else {
    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    throw Exception(response.body);
  }
}
