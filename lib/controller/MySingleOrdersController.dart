import 'package:traidbiz/models/ModelSingleOrder.dart';
import 'package:traidbiz/repositories/get_single_order_repository.dart';
import 'package:get/get.dart';

class MySingleOrdersController extends GetxController {
  RxBool isDataLoading = false.obs;
  Rx<ModelSingleOrderData> model = ModelSingleOrderData().obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    isDataLoading.value = false;
    getSingleOrderData(Get.arguments[0]).then((value) {
      isDataLoading.value = true;
      model.value = value;
      return null;
    });
  }
}
