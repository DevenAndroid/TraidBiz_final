import 'package:traidbiz/models/ModelGetCart.dart';
import 'package:traidbiz/models/ModelGetSocialLinks.dart';
import 'package:traidbiz/models/ModelMultiCurrencyList.dart';
import 'package:traidbiz/repositories/get_multicurrency_list_repository.dart';
import 'package:get/get.dart';
import 'package:traidbiz/repositories/get_social_links_repository.dart';

import '../repositories/get_cart_data_repository.dart';

class GetSocialLinksController extends GetxController {

  Rx<ModelGetSocialLinksResponse> model = ModelGetSocialLinksResponse().obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    getSocialLinksData().then((value) {
      isDataLoading.value = true;
      model.value = value;
      return null;
    });
  }
}
