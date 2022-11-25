import 'package:traidbiz/models/ModelMyBookings.dart';
import 'package:traidbiz/repositories/get_my_bookings_repository.dart';
import 'package:get/get.dart';

class MyBookingsController extends GetxController {
  RxBool isDataLoading = false.obs;
  Rx<ModelMyBookings> model = ModelMyBookings().obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    getMyBookings().then((value) {
      isDataLoading.value = true;
      model.value = value;
      return null;
    });
  }
}
