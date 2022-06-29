import 'package:dinelah/repositories/change_password_repository.dart';
import 'package:dinelah/res/app_assets.dart';
import 'package:dinelah/res/strings.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/ui/widget/common_button_white.dart';
import 'package:dinelah/ui/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

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

  RxBool isDataLoading = false.obs;
  final formKey = GlobalKey<FormState>();

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
                        child: Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      addWidth(12),
                      Text(
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
                  Center(
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  addHeight(screenSize.height * .01),
                  // Center(
                  //   child: Text(
                  //     'ChangePassword Lorem Ispus data for testing \n Lorem ipsum text',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //   ),
                  // ),
                  addHeight(screenSize.height * .03),
                  CommonTextFieldWidgetForgotPassword(
                    hint: Strings.enterYourOld,
                    controller: _oldPasswordController,
                    icon: Icons.lock,
                    bgColor: AppTheme.etBgColor,
                    isPassword: false,
                  ),
                  addHeight(screenSize.width * .05),
                  CommonTextFieldWidgetForgotPassword(
                    hint: Strings.enterYourNew,
                    controller: _newPasswordController,
                    icon: Icons.lock,
                    bgColor: AppTheme.etBgColor,
                    isPassword: false,
                  ),
                  addHeight(screenSize.width * .05),
                  CommonTextFieldWidgetForgotPassword(
                    hint: Strings.enterYourConfirm,
                    controller: _confirmPasswordController,
                    icon: Icons.lock,
                    bgColor: AppTheme.etBgColor,
                    isPassword: false,
                  ),
                  addHeight(screenSize.width * .08),
                  CommonButtonWhite(
                    buttonHeight: 6,
                    buttonWidth: 100,
                    mainGradient: AppTheme.primaryGradientColor,
                    text: Strings.buttonChangePassword,
                    isDataLoading: true,
                    textColor: AppTheme.primaryColor,
                    onTap: () {
                      setState(() {
                        if (_oldPasswordController.text.isEmpty &&
                            _oldPasswordController.text.length <= 16) {
                          Fluttertoast.showToast(
                            msg:
                                "password can't be empty or can be upto 16 characters", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM, // location
                            // duration
                          );
                        } else if (_newPasswordController.text.isEmpty &&
                            _newPasswordController.text.length <= 16) {
                          Fluttertoast.showToast(
                            msg:
                                "password can't be empty or can be upto 16 characters", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM, // location
                            // duration
                          );
                          print("==========::::::::new password empty hai");
                        } else if (_confirmPasswordController.text.isEmpty ||
                            _confirmPasswordController.text !=
                                _newPasswordController.text) {
                          print(
                              "==========::::::::Conform password empty hai ya same nhi hai new password ke");
                          Fluttertoast.showToast(
                            msg:
                                "Confirm password either empty or not same", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM, // location
                            // duration
                          );
                        } else {
                          print(
                              "==========::::::::Confirm password same hai new password ke");
                          getChangePassword(
                                  context,
                                  _oldPasswordController.text.toString(),
                                  _confirmPasswordController.text.toString())
                              .then((value) {
                            print("==========::::::::change password method");
                            if (value.status) {
                              print(":::::::::::::====>>>>>>>" +
                                  value.message.toString());
                              // Fluttertoast.showToast(
                              //   msg: value.message.toString(), // message
                              //   toastLength: Toast.LENGTH_SHORT, // length
                              //   gravity: ToastGravity.BOTTOM, // location
                              //   // duration
                              // );
                              _oldPasswordController.clear();
                              _newPasswordController.clear();
                              _confirmPasswordController.clear();
                              Get.off(CustomNavigationBar(
                                index: 2,
                              ));
                            } else {
                              print(":::::::::::::====>>>>>>>" +
                                  value.message.toString());
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
}
