import 'package:client_information/client_information.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:traidbiz/repositories/change_password_repository.dart';
import 'package:traidbiz/res/app_assets.dart';
import 'package:traidbiz/res/strings.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/routers/my_router.dart';
import 'package:traidbiz/ui/widget/common_button_white.dart';
import 'package:traidbiz/ui/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/ApiConstant.dart';
import '../widget/common_text_field_forgot_password.dart';
import 'bottom_Nav_Bar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var _oldPasswordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();
  SharedPreferences? pref;
  bool isLogin = true;
  RxBool isDataLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  ClientInformation? _clientInfo;
  getSf() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLogin = pref!.getString('user') != null ? true : false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssets.forgotBg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addHeight(screenSize.height * .05),
                  Row(
                    children: [
                      addWidth(4),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      addWidth(12),
                      const Text(
                        'Change Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  addHeight(screenSize.height * .08),
                  Center(
                      child: Image.asset(
                    AppAssets.forgotLogo,
                    height: 180,
                    width: 180,
                  )),
                  addHeight(screenSize.height * .06),
                  const Center(
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  addHeight(screenSize.height * .01),
                  addHeight(screenSize.height * .03),
                  CommonTextFieldWidgetForgotPassword(
                    hint: Strings.enterYourOld,
                    controller: _oldPasswordController,
                    icon: Icons.lock,
                    bgColor: AppTheme.etBgColor,
                    isPassword: false,
                    validator: (value) {},
                  ),
                  addHeight(screenSize.width * .05),
                  CommonTextFieldWidgetForgotPassword(
                    hint: Strings.enterYourNew,
                    controller: _newPasswordController,
                    icon: Icons.lock,
                    bgColor: AppTheme.etBgColor,
                    isPassword: true,
                    validator: (value) {},
                  ),
                  addHeight(screenSize.width * .05),
                  CommonTextFieldWidgetForgotPassword(
                    hint: Strings.enterYourConfirm,
                    controller: _confirmPasswordController,
                    icon: Icons.lock,
                    bgColor: AppTheme.etBgColor,
                    isPassword: true,
                    validator: (value) {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.toNamed(MyRouter.forgotPassword);
                        },
                        child: const Text(
                          "Forgot Password.?",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  CommonButtonWhite(
                    buttonHeight: 6,
                    buttonWidth: 100,
                    mainGradient: AppTheme.primaryGradientColor,
                    text: Strings.buttonChangePassword,
                    isDataLoading: true,
                    textColor: AppTheme.primaryColor,
                    onTap: () {
                      setState(() {
                        if (_newPasswordController.text.contains(RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{16,}$'))) {
                          Fluttertoast.showToast(
                            msg:
                                "Password must contain\n1 upper case\n1 lower case\n1 digit and\n1 special character", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM, // location
                            // duration
                          );
                        } else if (_confirmPasswordController.text.isEmpty ||
                            _confirmPasswordController.text !=
                                _newPasswordController.text) {
                          Fluttertoast.showToast(
                            msg:
                                "Confirm password either empty or not same", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM, // location
                            // duration
                          );
                        } else {
                          getChangePassword(
                                  context,
                                  _oldPasswordController.text.toString(),
                                  _confirmPasswordController.text.toString())
                              .then((value) async {
                            if (value.status) {
                              _oldPasswordController.clear();
                              _newPasswordController.clear();
                              _confirmPasswordController.clear();
                              _getClientInformation();
                              Get.back();
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              await preferences.clear();
                              Get.offAllNamed(MyRouter.logInScreen,
                                  arguments: ['mainScreen']);
                              //
                              // Get.offAndToNamed(MyRouter.logInScreen);
                              showToast(value.message);

                              // Get.off(const CustomNavigationBar(
                              //   index: 2,
                              // ));
                            } else {
                              Fluttertoast.showToast(
                                msg: value.message.toString(), // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity: ToastGravity.BOTTOM, // location
                                // duration
                              );
                            }
                            return null;
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
}
