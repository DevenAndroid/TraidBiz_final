import 'dart:convert';

import 'package:client_information/client_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:traidbiz/controller/ProfileController.dart';
import 'package:traidbiz/models/ModelLogIn.dart';
import 'package:traidbiz/res/size_config.dart';
import 'package:traidbiz/res/strings.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traidbiz/ui/screens/get_social_links_screen.dart';
import 'package:traidbiz/utils/ApiConstant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routers/my_router.dart';

class CustomDrawer extends StatefulWidget {
  final void Function(int index) onItemTapped;

  const CustomDrawer(this.onItemTapped, {Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final ProfileController _profileController = Get.put(ProfileController());
  bool apiConnected = false;

  String? userName = 'Guest';
  String? userEmail = '';
  String? userImage;
  RxBool isLoggedIn = false.obs;

  ClientInformation? _clientInfo;
  SharedPreferences? pref;
  bool isLogin = true;

  @override
  void initState() {
    super.initState();

    _profileController.getData();
  }

  getSf() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLogin = pref!.getString('user') != null ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Drawer(
      child: Obx(() {
        getSf();
        if (_profileController.isDataLoading.value) {
          userName = _profileController.model.value.data?.firstName.toString();
          userEmail = _profileController.model.value.data?.email;
          userImage = _profileController.model.value.data?.profileImage;
        }
        return Container(
          color: AppTheme.colorBackground,
          height: SizeConfig.heightMultiplier! * 100,
          width: SizeConfig.widthMultiplier! * 80,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: screenSize.width * 40,
                  color: AppTheme.newprimaryColor,
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.heightMultiplier! * 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Get.to(navigationPage.elementAt(_currentPage))
                          // Get.to(MyProfile());
                        },
                        child: Card(
                          elevation: 3,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                              margin: const EdgeInsets.all(4),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: const ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.white,
                              ),
                              height: SizeConfig.heightMultiplier! * 10,
                              width: SizeConfig.heightMultiplier! * 10,
                              child: userImage != null
                                  ? userImage!.isEmpty
                                      ? Image.asset(
                                          'assets/images/app-icon.png')
                                      : Image.network(
                                          userImage.toString(),
                                          fit: BoxFit.cover,
                                        )
                                  : const Icon(
                                      Icons.person,
                                      size: 40,
                                    )),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier! * 1.5,
                      ),
                      Text(userName != null ? userName.toString() : 'Guest',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: SizeConfig.heightMultiplier! * .5,
                      ),
                      Text(userEmail != null ? userEmail.toString() : '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: SizeConfig.heightMultiplier! * 1.8,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                // _drawerTile(
                //     active: true,
                //     title: Strings.account,
                //     icon: const Icon(
                //       Icons.person_outline,
                //       size: 22,
                //       color: AppTheme.textColorDarkBLue,
                //     ),
                //     onTap: () async {
                //       SharedPreferences pref =
                //           await SharedPreferences.getInstance();
                //       if (pref.getString('user') != null) {
                //         Get.back();
                //         widget.onItemTapped(4);
                //       } else {
                //         Get.back();
                //         Get.toNamed(MyRouter.logInScreen);
                //       }
                //     }),
                 ExpansionTile(
                    leading: const Icon(
                      Icons.person_outline,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    title: const Text('My Account Settings'),
                    children: [
                      _drawerTile(
                          active: true,
                          title: Strings.address,
                          icon: const Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: AppTheme.textColorDarkBLue,
                          ),
                          onTap: () async {
                            SharedPreferences pref =
                            await SharedPreferences.getInstance();
                            if (pref.getString('user') != null) {
                              Get.back();
                              Get.toNamed(MyRouter.addressScreen);
                            } else {
                              Get.back();
                              Get.toNamed(MyRouter.logInScreen);
                            }
                          }),
                      const Divider(
                        height: 1,
                      ),
                      _drawerTile(
                          active: true,
                          title: " Connect with us on Social",
                          icon: const Icon(
                            Icons.golf_course_outlined,
                            size: 20,
                            color: AppTheme.textColorDarkBLue,
                          ),
                          onTap: (){
                            Get.back();
                            Get.to(const GetSocialLinksScreen());
                          }),
                    ]
                ),


                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: 'Credit Orders',
                    icon: const Icon(
                      Icons.account_balance,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _creditOrders),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.myWallet,
                    icon: const Icon(
                      Icons.wallet_outlined,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _myWallet),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.orders,
                    icon: const Icon(
                      Icons.list_alt,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      if (pref.getString('user') != null) {
                        Get.back();
                        Get.toNamed(MyRouter.myOrdersScreen);
                      } else {
                        Get.back();
                        Get.toNamed(MyRouter.logInScreen);
                      }
                    }),

                // myCart Remove by Client
                // const Divider(
                //   height: 1,
                // ),
                // _drawerTile(
                //     active: true,
                //     title: Strings.myCart,
                //     icon: const Icon(
                //       Icons.shopping_cart_outlined,
                //       size: 22,
                //       color: AppTheme.textColorDarkBLue,
                //     ),
                //     onTap: () async {
                //       Get.back();
                //       widget.onItemTapped(1);
                //     }),


                // Used in My account Settings
                // const Divider(
                //   height: 1,
                // ),
                // SizedBox(
                //   height: SizeConfig.heightMultiplier! * .5,
                // ),
                // _drawerTile(
                //     active: true,
                //     title: Strings.address,
                //     icon: const Icon(
                //       Icons.location_on_outlined,
                //       size: 22,
                //       color: AppTheme.textColorDarkBLue,
                //     ),
                //     onTap: () async {
                //       SharedPreferences pref =
                //           await SharedPreferences.getInstance();
                //       if (pref.getString('user') != null) {
                //         Get.back();
                //         Get.toNamed(MyRouter.addressScreen);
                //       } else {
                //         Get.back();
                //         Get.toNamed(MyRouter.logInScreen);
                //       }
                //     }),


                const Divider(
                  height: 1,
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier! * .5,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.savedAddress,
                    icon: const Icon(
                      Icons.location_city_outlined,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _savesAddress),

                //accountDetails Remove by Client
                // const Divider(
                //   height: 1,
                // ),
                // SizedBox(
                //   height: SizeConfig.heightMultiplier! * .5,
                // ),
                // _drawerTile(
                //     active: true,
                //     title: Strings.accountDetails,
                //     icon: const Icon(
                //       Icons.account_box_outlined,
                //       size: 22,
                //       color: AppTheme.textColorDarkBLue,
                //     ),
                //     onTap: _accountDetails),



                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.downloads,
                    icon: const Icon(
                      Icons.download_outlined,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _downLoads),

                // notification Remove By Client
                // const Divider(
                //   height: 1,
                // ),
                // _drawerTile(
                //     active: true,
                //     title: Strings.notification,
                //     icon: const Icon(
                //       Icons.notifications_none,
                //       size: 22,
                //       color: AppTheme.textColorDarkBLue,
                //     ),
                //     onTap: () async {
                //       SharedPreferences pref =
                //           await SharedPreferences.getInstance();
                //       if (pref.getString('user') != null) {
                //         Get.back();
                //         Get.toNamed(MyRouter.notificationScreen);
                //       } else {
                //         Get.back();
                //         Get.toNamed(MyRouter.logInScreen);
                //       }
                //     }),


                const Divider(
                  height: 1,
                ),
                _drawerTile(
                  active: true,
                  title: Strings.shippingpolicy,
                  icon: const Icon(
                    Icons.shopping_cart_checkout_outlined,
                    size: 22,
                    color: AppTheme.textColorDarkBLue,
                  ),
                  onTap: _shippingPolicy,
                ),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: "Ratings and Reviews",
                    icon: const Icon(
                      Icons.attach_money_outlined,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _ratingsAndReviews),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.refundandreturnspolicy,
                    icon: const Icon(
                      Icons.attach_money_outlined,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _refundAndReturnPolicy),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.payments_options,
                    icon: const Icon(
                      Icons.money,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _paymentsOptions),

                // aboutUs Remove by Client
                // const Divider(
                //   height: 1,
                // ),
                // _drawerTile(
                //     active: true,
                //     title: Strings.aboutUs,
                //     icon: const Icon(
                //       Icons.details,
                //       size: 22,
                //       color: AppTheme.textColorDarkBLue,
                //     ),
                //     onTap: _aboutUs),


                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.inquiries,
                    icon: const Icon(
                      Icons.details,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _inquiry),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.whyTraidbiz,
                    icon: const Icon(
                      Icons.card_giftcard_outlined,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _whyTraidBiz),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.sellonTraidBiz,
                    icon: const Icon(
                      Icons.shopping_cart_checkout_outlined,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _sellOnTraidBiz),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.privacyPolicy,
                    icon: const Icon(
                      Icons.list_alt,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _privacyPolicy),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.termsAndConditions,
                    icon: const Icon(
                      Icons.security,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _termsAndConditions),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.ContactUs,
                    icon: const Icon(
                      Icons.phone_locked_sharp,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _contactUs),
                const Divider(
                  height: 1,
                ),
                _drawerTile(
                    active: true,
                    title: Strings.helpCenter,
                    icon: const Icon(
                      Icons.person_add_alt_1_sharp,
                      size: 22,
                      color: AppTheme.textColorDarkBLue,
                    ),
                    onTap: _helpCenter),

                // referAndEarn Remove By Client
                // const Divider(
                //   height: 1,
                // ),
                // _drawerTile(
                //     active: true,
                //     title: Strings.referAndEarn,
                //     icon: const Icon(
                //       Icons.card_giftcard_outlined,
                //       size: 22,
                //       color: AppTheme.textColorDarkBLue,
                //     ),
                //     onTap: _referAndEarn),




                !isLogin ? const SizedBox.shrink() : const Divider(),
                !isLogin
                    ? const SizedBox.shrink()
                    : _drawerTile(
                        active: true,
                        title: Strings.logOut,
                        icon: const Icon(
                          Icons.power_settings_new,
                          size: 22,
                          color: AppTheme.textColorDarkBLue,
                        ),
                        onTap: () async {
                          _getClientInformation();
                          Get.back();
                          await FirebaseAuth.instance.signOut();
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          await preferences.clear();

                          Get.offAllNamed(MyRouter.logInScreen,
                              arguments: ['mainScreen']);
                        }),
              ],
            ),
          ),
        );
      }),
    );
  }

  //to get device Id
  Future<void> _getClientInformation() async {
    ClientInformation? info;
    try {
      info = await ClientInformation.fetch();
    } on PlatformException {
      // print('Failed to get client information');
    }
    if (!mounted) return;

    setState(() {
      _clientInfo = info!;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceId', _clientInfo!.deviceId.toString());
  }

  Widget _drawerTile(
      {required bool active,
      required String title,
      required Icon icon,
      required VoidCallback onTap}) {
    return ListTile(
      selectedTileColor: AppTheme.etBgColor,
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: active ? Colors.black : Colors.grey,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: active ? onTap : null,
    );
  }

  _shippingPolicy() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/shipping-policy/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/shipping-policy/';
    }

    await launch(url);
  }

  _refundAndReturnPolicy() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/refund_returns/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/refund_returns/';
    }

    await launch(url);
  }

  _ratingsAndReviews() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user = ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));

      showToast("Under Development");
      // url = 'https://traidbiz.com/refund_returns/?login_cookie=${user.cookie}&app_page=true';
    } else {
      showToast("Under Development");
      // url = 'https://traidbiz.com/refund_returns/';
    }

    await launch(url);
  }

  _paymentsOptions() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/payments-options/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/payments-options/';
    }

    await launch(url);
  }

  _aboutUs() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/about_us/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/about_us/';
    }

    await launch(url);
  }

  // _aboutUs() async {
  //   ModelLogInData? user =
  //       ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
  //   user.cookie;
  //   var url =
  //       'https://traidbiz.com/about-us/?login_cookie=${user.cookie}&app_page=true';
  //   if (await canLaunchUrl(Uri(path: "https://www.google.com"))) {
  //     await launchUrl(Uri(path: "https://www.google.com"));
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  _whyTraidBiz() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/why-traidbiz/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/why-traidbiz/';
    }

    await launch(url);
  }

  _sellOnTraidBiz() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/vendor-membership/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/vendor-membership/';
    }

    await launch(url);
  }

  _privacyPolicy() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/privacy-policy/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/privacy-policy/';
    }

    await launch(url);
  }

  _termsAndConditions() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/term-conditions/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/term-conditions/';
    }

    await launch(url);
  }

  _contactUs() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/contact-us/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/contact-us/';
    }

    await launch(url);
  }

  _helpCenter() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/help-centre?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/help-centre';
    }

    await launch(url);
  }

  _referAndEarn() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/why-traidbiz/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/why-traidbiz/';
    }

    await launch(url);
  }

  //Newly added on 16 sep 2022
  _downLoads() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/my-account/downloads/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/my-account/downloads/';
    }

    await launch(url);
  }
  _savesAddress() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/my-account/edit-address/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/my-account/edit-address/';
    }

    await launch(url);
  }
  _accountDetails() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/my-account/edit-account/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/my-account/edit-account/';
    }

    await launch(url);
  }
  _myWallet() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/my-account/woo-wallet/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/my-account/woo-wallet/';
    }

    await launch(url);
  }
  _inquiry() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/my-account/inquiry/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/my-account/inquiry/';
    }

    await launch(url);
  }
  _creditOrders() async {
    var url;
    if (pref!.getString('user') != null) {
      ModelLogInData? user =
          ModelLogInData.fromJson(jsonDecode(pref!.getString('user')!));
      url =
          'https://traidbiz.com/my-account/credit-orders/?login_cookie=${user.cookie}&app_page=true';
    } else {
      url = 'https://traidbiz.com/my-account/credit-orders/';
    }

    await launch(url);
  }
}
