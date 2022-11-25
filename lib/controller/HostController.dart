import 'package:traidbiz/models/ModelAttributeData.dart';
import 'package:traidbiz/models/ModelHomeData.dart';
import 'package:traidbiz/repositories/get_attribute_data_repository.dart';
import 'package:traidbiz/repositories/get_home_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../models/ModelStoreInfo.dart';
import '../repositories/get_store_info_repository.dart';

class HostController extends GetxController {
  Rx<ModelStoreInfoData> model = ModelStoreInfoData().obs;
  //Rx<ModelGetAttributeData> modelGetAttribute= ModelGetAttributeData().obs;
  RxBool isDataLoading = false.obs;
  var id;
  final currentIndex = 0.obs;
  final currentIndex1 = 0.obs;

  final productQuantity = 1.obs;
  increment() {
    productQuantity.value++;
  }

  decrement() {
    if (productQuantity <= 1) {
      Fluttertoast.showToast(
          msg: "Minimum quantity must be 1",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      productQuantity.value--;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    id = Get.arguments[0];
    getStoreInfo(id).then((value) {
      isDataLoading.value = true;
      model.value = value;
      return null;
    });
  }

  getHostData() {
    getStoreInfo(id).then((value) {
      isDataLoading.value = true;
      model.value = value;
      return null;
    });
  }
}
