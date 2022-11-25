import 'package:traidbiz/models/ModelGetOrder.dart';
import 'package:traidbiz/repositories/get_order_data_repository.dart';
import 'package:get/get.dart';

class MyOrdersController extends GetxController {
  RxBool isDataLoading = false.obs;
  Rx<ModelGetOrdersData> model = ModelGetOrdersData().obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    getOrdersData().then((value) {
      isDataLoading.value = true;
      model.value = value;
      return null;
    });
  }
}
