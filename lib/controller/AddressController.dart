import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:traidbiz/models/ModelAddress.dart';
import 'package:traidbiz/repositories/get_address_repository.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  Rx<ModelGetAddresss> model = ModelGetAddresss().obs;
  RxBool isDataLoading = false.obs;


  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String shippingCountry = "";



  @override
  void onInit() {
    super.onInit();
    getAddressData().then((value) {
      log("RESPONSE FORM ADDRESS SCREENssss"+jsonEncode(value));
      isDataLoading.value = true;
      model.value = value;
        fnameController.text = model.value.data!.shippingAddress.shippingFirstName
            .toString();
        lnameController.text = model.value.data!.shippingAddress.shippingLastName
            .toString();
        address1.text = model.value.data!.shippingAddress.shippingAddress_1
            .toString();
        address2.text = model.value.data!.shippingAddress.shippingAddress_2
            .toString();
        postcodeController.text = model.value.data!.shippingAddress.shippingPostcode
            .toString();
        cityController.text = model.value.data!.shippingAddress.shippingCity
            .toString();
        shippingCountry = model.value.data!.shippingAddress.shippingCountry
            .toString();
    });
  }
}
