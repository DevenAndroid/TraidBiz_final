import 'dart:convert';
import 'dart:io';

import 'package:traidbiz/helper/Helpers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/ModelBookableEndDate.dart';
import '../utils/ApiConstant.dart';
import '../routers/my_router.dart';
import 'package:get/get.dart';

Future<ModelBookableEndDateData> getBookableEndDate(BuildContext context,
    productId, dateYear, dateMonth, dateDay, dateTime) async {
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // ModelLogInData? user = ModelLogInData.fromJson(jsonDecode(pref.getString('user')!));
  var map = <String, dynamic>{};
  // map['cookie'] = user.cookie;
  map['product_id'] = productId;
  map['date_year'] = dateYear;
  map['date_month'] = dateMonth;
  map['date_day'] = dateDay;
  map['date_time'] = dateTime;

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  // OverlayEntry loader = Helpers.overlayLoader(context);
  // Overlay.of(context)!.insert(loader);

  http.Response response = await http.post(
      Uri.parse(ApiUrls.getBookableEndTime),
      body: jsonEncode(map),
      headers: headers);

  print("<<<<<<<getBookableEndTime from repository=======>" +
      response.body.toString());
  if (response.statusCode == 200) {
    // Helpers.hideLoader(loader);

    return ModelBookableEndDateData.fromJson(json.decode(response.body));
  } else {
    Get.offAndToNamed(MyRouter.serverErrorUi,
        arguments: [response.body.toString(), response.statusCode.toString()]);

    // Helpers.hideLoader(loader);
    Helpers.createSnackBar(context, response.body.toString());
    throw Exception(response.body);
  }
}
