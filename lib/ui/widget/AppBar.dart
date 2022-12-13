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

AppBar buildAppBar(context,
    isProfilePage,
    title,
    _scaffoldKey,
    currentPage,) {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  //AppBarController _appBarController = Get.put(AppBarController());
  final MultiCurrencyListController multiCurrencyListController = Get.put(
      MultiCurrencyListController());
  final ProfileController _profileController = Get.put(ProfileController());

  // to refresh currency

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
        builder: (context) =>
            IconButton(
                padding: const EdgeInsets.all(0.0),
                icon: IconButton(
                  icon: Image.asset(AppAssets.drawerIcon),
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                ),
                onPressed: () =>
                {
                  //  Get.toNamed(MyRouter.notification)
                })),

    actions: [
      Visibility(
        visible: title != 'My Profile',
        child: Obx(() {
          return IconButton(
            icon: multiCurrencyListController.currentCurrency.value == "" ?
            const Icon(
              Icons.currency_exchange,
              color: AppTheme.colorWhite,
            ) :
            Text(
              multiCurrencyListController.currentCurrency.value,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
              ),
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
                      insetPadding: EdgeInsets.symmetric(
                          horizontal: 18, vertical: MediaQuery
                          .of(context)
                          .size
                          .height * .06),
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
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  Divider(height: 1,),
                              shrinkWrap: true,
                              itemCount: multiCurrencyListController
                                  .model.value.data!.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return _buildRow(
                                    multiCurrencyListController
                                        .model.value.data![index],
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
          );
        }),
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
Widget _buildRow(Data data, int index) {
  final MultiCurrencyListController multiCurrencyListController = Get.put(
      MultiCurrencyListController());
  return ListTile(
    onTap: () {
      getUpdateUserCurrency(data.code.toString()).then((value) {
        showToast(value.message);
        multiCurrencyListController.getData();
        final GetHomeController controller = Get.put(GetHomeController());
        controller.getData();
        controller.isDataLoading.isTrue
            ? EasyLoading.show(dismissOnTap: true)
            : EasyLoading.dismiss();
        Get.offAndToNamed(MyRouter.customBottomBar);
      });
    },
    selectedTileColor: Colors.blue.withOpacity(.1),
    selected: data.isSelected,
    minVerticalPadding: 0,
    contentPadding: EdgeInsets.zero,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(data.title.toString())),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xfff0f3fc),
                borderRadius: BorderRadius.circular(20)),
            padding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Text(data.code.toString()),
          ),
        ],
      ),
    ),
  );
}
