import 'dart:convert';
import 'dart:io';

import 'package:traidbiz/models/ModelLogIn.dart';
import 'package:traidbiz/models/ModelProfileFields.dart';
import 'package:traidbiz/repositories/get_profile_field_repository.dart';
import 'package:traidbiz/utils/ApiConstant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  Rx<ModelProfileFieldData> model = ModelProfileFieldData().obs;
  RxBool isDataLoading = false.obs;
  File? image;
  final ImagePicker picker = ImagePicker();
  TextEditingController firstNameController = TextEditingController();
  // TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? fName;
  var index;
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  getUser() async {
    isLoggedIn.value = await isLogIn();
    showToast(isLoggedIn.value.toString());
  }

  getData() {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    getProfileFieldData().then((value) {
      isDataLoading.value = true;
      model.value = value;
      // pref.setString('user', jsonEncode(value.data));
      return null;
    });
  }
}
