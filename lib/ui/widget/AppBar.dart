import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:traidbiz/controller/GetHomeController.dart';
import 'package:traidbiz/controller/ProfileController.dart';
import 'package:traidbiz/models/ModelMultiCurrencyList.dart';
import 'package:traidbiz/repositories/update_user_currency.dart';
import 'package:traidbiz/res/app_assets.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/routers/my_router.dart';
import 'package:traidbiz/utils/ApiConstant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/MultiCurrencyController.dart';
import '../../models/ModelLogIn.dart';
import '../screens/bottom_Nav_Bar.dart';

AppBar buildAppBar(
  context,
  isProfilePage,
  title,
  _scaffoldKey,
  currentPage,
) {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  //AppBarController _appBarController = Get.put(AppBarController());
  final MultiCurrencyListController multiCurrencyListController =
      Get.put(MultiCurrencyListController());
  final ProfileController _profileController = Get.put(ProfileController());

  // to refresh currency
  final GetHomeController homecontroller = Get.put(GetHomeController());

  String? userImage;

  return AppBar(
    backgroundColor: Colors.transparent,
    //backgroundColor: AppTheme.colorBackground,
    elevation: 0,
    // centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(
          color: AppTheme.colorWhite, fontWeight: FontWeight.bold),
    ),
    leading: Builder(
        builder: (context) => IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: IconButton(
              icon: Image.asset(AppAssets.drawerIcon),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            onPressed: () => {
                  //  Get.toNamed(MyRouter.notification)
                })),

    actions: [
      Visibility(
        visible: title != 'My Profile',
        child: IconButton(
          icon: const Icon(
            Icons.currency_exchange,
            color: AppTheme.colorWhite,
          ),
          onPressed: () async {
            // if(multiCurrencyListController.isDataLoading.value){}
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 16,
                    child: multiCurrencyListController.isDataLoading.value
                        ? Column(
                            children: [
                              const SizedBox(height: 20),
                              const Center(
                                  child: Text(
                                'Select Currency',
                                style: TextStyle(fontSize: 18),
                              )),
                              const SizedBox(height: 20),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: multiCurrencyListController
                                      .model.value.data!.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return _buildRow(
                                        multiCurrencyListController
                                            .model.value.data!,
                                        index);
                                  },
                                ),
                              ),
                            ],
                          )
                        : const Center(child: CircularProgressIndicator()),
                  );
                });
          },
        ),
      ),
      Visibility(
        visible: title != 'My Profile',
        child: IconButton(
          icon: const Icon(
            Icons.notifications,
            color: AppTheme.colorWhite,
          ),
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            if (pref.getString('user') != null) {
              Get.toNamed(MyRouter.notificationScreen);
            } else {
              Get.toNamed(MyRouter.logInScreen);
            }
          },
        ),
      ),
      Visibility(
        visible: title != 'My Profile',
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Obx(() {
            if (_profileController.isDataLoading.value) {
              userImage = _profileController.model.value.data?.profileImage;
            }
            return Visibility(
              visible: true,
              child: GestureDetector(
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  if (pref.getString('user') != null) {
                    ModelLogInData? user = ModelLogInData.fromJson(
                        jsonDecode(pref.getString('user')!));

                    Get.off(const CustomNavigationBar(
                      index: 4,
                    ));
                  } else {
                    Get.toNamed(MyRouter.logInScreen);
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Container(
                      height: 34,
                      width: 34,
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.brown),
                      child: userImage != null
                          ? userImage!.isEmpty
                              ? Image.asset('assets/images/app-icon.png')
                              : Image.network(userImage.toString(),
                                  fit: BoxFit.cover)
                          : Image.asset(
                              AppAssets.logInLogo,
                              fit: BoxFit.fill,
                            )),
                ),
              ),
            );
          }),
        ),
      )
    ],
  );
}

/*
getUser() async {
  isLoggedIn.value = await isLogIn();
  //showToast(isLoggedIn.value.toString());
}*/
Widget _buildRow(List<Data> data, int index) {
  return InkWell(
    onTap: () {
      print('object' + data[index].code.toString());
      getUpdateUserCurrency(data[index].code.toString()).then((value) {
        showToast(value.message);

        final GetHomeController homecontroller = Get.put(GetHomeController());
        homecontroller.getData();
        homecontroller.isDataLoading.isTrue
            ? EasyLoading.show(dismissOnTap: true)
            : EasyLoading.dismiss();
        Get.offAndToNamed(MyRouter.customBottomBar);
      });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Container(height: 1, color: const Color(0xff9aa1b8)),
          Row(
            children: <Widget>[
              // CircleAvatar(
              //   radius: 24,
              //   backgroundColor: const Color(0xfff0f3fc),
              //   child: Image.asset(
              //     'assets/images/money.png',
              //     color: const Color(0xff9aa1b8),
              //     height: 24,
              //   ),
              // ),
              Expanded(child: Text(data[index].title.toString())),
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xfff0f3fc),
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Text(data[index].code.toString()),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}
