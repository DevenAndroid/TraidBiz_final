import 'package:traidbiz/models/ModelGetCart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../repositories/get_cart_data_repository.dart';

class CartController extends GetxController {
  RxBool isDataLoading = false.obs;
  Rx<ModelGetCartData> model = ModelGetCartData().obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    getCartData().then((value) {
      isDataLoading.value = true;
      model.value = value;
      return null;
    });
  }
}
