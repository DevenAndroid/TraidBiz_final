import 'package:traidbiz/models/ModelAllAttributes.dart';
import 'package:traidbiz/models/ModelSearchProduct.dart';
import 'package:traidbiz/models/PopularProduct.dart';
import 'package:traidbiz/repositories/get_search_product_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traidbiz/utils/ApiConstant.dart';

class SearchController extends GetxController {
  Rx<ModelSearchProduct> model = ModelSearchProduct().obs;
  Rx<ModelAllAttributes> modelAttribute = ModelAllAttributes().obs;
  var mListProducts = List<ModelProduct>.empty(growable: true).obs;
  RxBool isDataLoading = false.obs;
  RxString searchKeyboard = ''.obs;
  RxString productType = ''.obs;
  RxString minPrice = ''.obs;
  RxString maxPrice = ''.obs;
  RxString rating = ''.obs;
  RxString sortBy = ''.obs;

  BuildContext? context;

  @override
  void onInit() {
    super.onInit();
  }

  void getMapData() {
    getData(searchKeyboard.value, productType.value, minPrice.value,
        maxPrice.value, rating.value, sortBy.value, modelAttribute.value);
  }

  void getData(searchKeyboard, productType, minPrice, maxPrice, rating, sortBy,
      modelAttribute) {
    isDataLoading.value = false;
    getSearchProductData(context, searchKeyboard, productType, minPrice,
            maxPrice, rating, sortBy, modelAttribute)
        .then((value) {
      isDataLoading.value = true;
      mListProducts.clear();
      mListProducts.addAll(value.data!.products);
      model.value = value;
      return null;
    });
  }
}
