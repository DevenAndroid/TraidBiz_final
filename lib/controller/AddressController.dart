import 'package:traidbiz/models/ModelAddress.dart';
import 'package:traidbiz/repositories/get_address_repository.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  Rx<ModelGetAddresss> model = ModelGetAddresss().obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAddressData().then((value) {
      print(value.data!.billingAddress.billingCountry.toString() +
          "RESPONSE FORM ADDRESS SCREENssss");
      isDataLoading.value = true;
      model.value = value;
      return null;
    });
  }
}
