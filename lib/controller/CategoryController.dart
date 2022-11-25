import 'package:traidbiz/models/ModelCategoryData.dart';
import 'package:traidbiz/models/ModelCategoryProducts.dart';
import 'package:traidbiz/repositories/get_category_products.dart';
import 'package:traidbiz/utils/ApiConstant.dart';
import 'package:get/get.dart';

import '../repositories/category_repository.dart';
import '../repositories/update_user_currency.dart';

class CategoryController extends GetxController {
  Rx<ModelCategoryData> catModel = ModelCategoryData().obs;
  Rx<ModelCategoryProductData> model = ModelCategoryProductData().obs;

  RxBool isDataLoading = false.obs;
  RxBool isCategorySelected = false.obs;

  final currentIndex = 0.obs;
  final currentIndex1 = 0.obs;

  final productQuantity = 1.obs;
  increment() {
    productQuantity.value++;
  }

  decrement() {
    if (productQuantity <= 1) {
      showToast("Minimum quantity must be 1");
    } else {
      productQuantity.value--;
    }
  }

  void getProduct(id) {
    getCategoryProductData(id).then((value) {
      isDataLoading.value = true;
      model.value = value;
      return null;
    });
  }

  void getCategory() {
    getCategoryData().then((value) {
      isDataLoading.value = true;
      catModel.value = value;
      return null;
    });
  }
}
