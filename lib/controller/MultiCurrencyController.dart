import 'package:traidbiz/models/ModelGetCart.dart';
import 'package:traidbiz/models/ModelMultiCurrencyList.dart';
import 'package:traidbiz/repositories/get_multicurrency_list_repository.dart';
import 'package:get/get.dart';

import '../repositories/get_cart_data_repository.dart';

class MultiCurrencyListController extends GetxController {
  RxBool isDataLoading = false.obs;
  Rx<ModelMultiCurrencyList> model = ModelMultiCurrencyList().obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    getMultiCurrencyList().then((value) {
      isDataLoading.value = true;
      model.value = value;
      return null;
    });
  }
}
