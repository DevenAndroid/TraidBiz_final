import 'package:traidbiz/models/ModelMultiCurrencyList.dart';
import 'package:traidbiz/repositories/get_multicurrency_list_repository.dart';
import 'package:get/get.dart';

class MultiCurrencyListController extends GetxController {
  RxBool isDataLoading = false.obs;
  Rx<ModelMultiCurrencyList> model = ModelMultiCurrencyList().obs;
  RxString currentCurrency = "".obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    getMultiCurrencyList().then((value) {
      isDataLoading.value = true;
      model.value = value;
      if(model.value.data != null) {
        for (var item in model.value.data!) {
          if(item.isSelected){
          currentCurrency.value = item.code.toString();
          }
        }
      }
    });
  }
}
