import 'package:client_information/client_information.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:traidbiz/repositories/user_signup_repository.dart';
import 'package:traidbiz/res/app_assets.dart';
import 'package:traidbiz/res/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../helper/Helpers.dart';
import '../../repositories/verify_signup_user_email_repo.dart';
import '../../res/theme/theme.dart';
import '../../routers/my_router.dart';
import '../widget/common_button.dart';
import '../widget/common_text_field_sign_up.dart';
import '../widget/common_widget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? countryPostCode;
  String? countryIsoCode;

  var userNameController = TextEditingController();
  var mobileController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();

  RxBool isDataLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  late ClientInformation _clientInfo;

  // var googledata=Get.arguments;
  var userGoogleEmail;
  var userGoogleDisplayname;
  var googleAccessTokenId;
  var socialTypeGoogle;
  var userLoginType = 'manual';

  RxBool isPasswordShow = true.obs;
  RxBool isConfirmPasswordShow = true.obs;

  // bool? isPassword = true;

  @override
  void initState() {
    super.initState();
    _getClientInformation();

    googleAccessTokenId =
        Get.arguments == null ? '' : Get.arguments[0].toString();
    userGoogleEmail = Get.arguments == null ? '' : Get.arguments[1].toString();
    userGoogleDisplayname =
        Get.arguments == null ? '' : Get.arguments[2].toString();
    socialTypeGoogle = Get.arguments == null ? '' : Get.arguments[3].toString();

    userNameController.text = userGoogleEmail;
  }

  Future<void> _getClientInformation() async {
    ClientInformation? info;
    try {
      info = await ClientInformation.fetch();
    } on PlatformException {
      print('Failed to get client information');
    }
    if (!mounted) return;

    setState(() {
      _clientInfo = info!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppAssets.logInBg,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: 50,
              child: Image.asset(
                AppAssets.logoWelcome,
                width: screenSize.width * 0.7,
                height: 60,
              ),
            ),
            Positioned(
                bottom: 24,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: screenSize.width,
                          child: Card(
                            elevation: 5,
                            color: Colors.white.withOpacity(0.88),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: const EdgeInsets.fromLTRB(18, 56, 18, 24),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  addHeight(32),
                                  Text(
                                    Strings.buttonSignUp,
                                    style: const TextStyle(
                                        color: AppTheme.newprimaryColor,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  addHeight(2),
                                  labelText(Strings.signUpToYourAccount),
                                  addHeight(16),
                                  CommonTextFieldWidgetSignUp(
                                    hint: 'Email',
                                    controller: userNameController,
                                    icon: Icons.email_outlined,
                                    isPassword: false,
                                    type: '1',
                                  ),
                                  addHeight(8),
                                  IntrinsicHeight(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: AppTheme.primaryColorVariant,width: 1.0,),
                                          borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      child: CountryPickerDropdown(
                                        isExpanded: true,
                                        initialValue: 'fj',
                                        itemBuilder: _buildDropdownItem,
                                        onValuePicked: (Country country) {
                                          print(country.name);
                                          print(country.phoneCode);
                                          countryPostCode = country.phoneCode;
                                          countryIsoCode = country.isoCode.toLowerCase();
                                          print("object$countryPostCode");
                                          print("object1$countryIsoCode");

                                        },
                                      ),
                                    ),
                                  ),
                                  addHeight(8),
                                  IntrinsicHeight(
                                      child: Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          controller: mobileController,
                                          // obscureText: isPasswordShow.value,
                                          validator: (value) {if (value!.trim().isEmpty) {
                                              return 'Mobile Number can\'t be empty.';
                                            }},
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                              hintText: Strings.mobileNumber,
                                              counterText: "",
                                              filled: true,
                                              errorMaxLines: 2,
                                              fillColor: AppTheme.colorEditFieldBg,
                                              focusColor: AppTheme.colorEditFieldBg,
                                              contentPadding:
                                              const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: AppTheme.primaryColorVariant),
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              enabledBorder: const OutlineInputBorder(
                                                  borderSide:
                                                  BorderSide(color: AppTheme.primaryColorVariant),
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                              border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: AppTheme.primaryColor, width: 2.0),
                                                  borderRadius: BorderRadius.circular(5.0)),
                                              // prefixIcon: CountryPickerDropdown(
                                              //   initialValue: 'in',
                                              //   itemBuilder: _buildDropdownItem,
                                              //   onValuePicked: (Country country) {
                                              //     print("${country.name}");
                                              //     print("${country.phoneCode}");
                                              //   },
                                              // ),
                                              prefixIcon: const Icon(Icons.phone_android_outlined),
                                              suffixIcon: const SizedBox.shrink()),
                                        ),
                                      ),
                                    ),
                                  addHeight(8),
                                  Obx(() => IntrinsicHeight(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: passwordController,
                                                obscureText:
                                                    isPasswordShow.value,
                                                validator: (value) {
                                                  // if (value!.trim().isEmpty)
                                                  // {
                                                  //   return 'Please enter password';
                                                  // } else if (value.length < 8) {
                                                  //   return 'Password must be greater then 8';
                                                  // } else if (value.length >
                                                  //     24) {
                                                  //   return 'Password must be less then 24';
                                                  // }
                                                  if (value!.contains(RegExp(
                                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))) {
                                                  } else {
                                                    return 'Password must contain\n1 upper case\n1 lower case\n1 digit and\n1 special character';
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLength: 32,
                                                textInputAction:
                                                    TextInputAction.done,
                                                decoration: InputDecoration(
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText: Strings.password,
                                                    counterText: "",
                                                    filled: true,
                                                    fillColor: AppTheme
                                                        .colorEditFieldBg,
                                                    focusColor: AppTheme
                                                        .colorEditFieldBg,
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 18),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: AppTheme
                                                              .primaryColorVariant),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    enabledBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: AppTheme
                                                                .primaryColorVariant),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0))),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: AppTheme
                                                                    .primaryColor,
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5.0)),
                                                    prefixIcon: const Icon(
                                                      Icons.lock,
                                                      color: Colors.grey,
                                                    ),
                                                    suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        isPasswordShow.value =
                                                            !isPasswordShow
                                                                .value;
                                                      },
                                                      child: Icon(
                                                          isPasswordShow.value
                                                              ? CupertinoIcons
                                                                  .eye_slash_fill
                                                              : CupertinoIcons
                                                                  .eye,
                                                          color: Colors.grey),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  addHeight(8),
                                  Obx(() => IntrinsicHeight(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    passwordConfirmController,
                                                obscureText:
                                                    isConfirmPasswordShow.value,
                                                validator: (value) {
                                                  if (value!.trim().isEmpty) {
                                                    return 'Please enter confirm password';
                                                  } else if (value.length < 4) {
                                                    return 'Confirm password must be greater then 8';
                                                  } else if (value.length >
                                                      16) {
                                                    return 'Confirm password must be less then 16';
                                                  } else if (value !=
                                                      passwordController.text) {
                                                    return 'Entered password not match';
                                                  }
                                                  /* else {
                                                if (value!.trim().isEmpty) {
                                                  return 'Please enter username or email';
                                                } else if (value.length < 4) {
                                                  return 'Please enter valid username or email';
                                                }
                                              }*/
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.text,
                                                maxLength: 32,
                                                textInputAction:
                                                    TextInputAction.done,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        Strings.confirmPassword,
                                                    counterText: "",
                                                    filled: true,
                                                    fillColor: AppTheme
                                                        .colorEditFieldBg,
                                                    focusColor: AppTheme
                                                        .colorEditFieldBg,
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 18),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: AppTheme
                                                              .primaryColorVariant),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    enabledBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: AppTheme
                                                                .primaryColorVariant),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0))),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: AppTheme
                                                                    .primaryColor,
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5.0)),
                                                    prefixIcon: const Icon(
                                                      Icons.lock,
                                                      color: Colors.grey,
                                                    ),
                                                    suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        isConfirmPasswordShow
                                                                .value =
                                                            !isConfirmPasswordShow
                                                                .value;
                                                      },
                                                      child: Icon(
                                                          isConfirmPasswordShow
                                                                  .value
                                                              ? CupertinoIcons
                                                                  .eye_slash_fill
                                                              : CupertinoIcons
                                                                  .eye,
                                                          color: Colors.grey),
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  addHeight(16),
                                  Obx(
                                    () => CommonButton(
                                        buttonHeight: 6.5,
                                        buttonWidth: 95,
                                        mainGradient:
                                            AppTheme.secondaryGradientColor,
                                        text: Strings.buttonSignUp,
                                        isDataLoading: isDataLoading.value,
                                        textColor: Colors.white,
                                        onTap: () {
                                          if (formKey.currentState!.validate()) {
                                            if (passwordController.text.trim() !=
                                                passwordConfirmController.text.trim()) {
                                              Helpers.createSnackBar(context,
                                                  'Password not matched');
                                            } else {
                                              if (socialTypeGoogle != null) {
                                                register(
                                                        userNameController.text,
                                                    countryPostCode!=null ? "+$countryPostCode" : "+679",
                                                    countryIsoCode==null ?"fj":countryIsoCode.toString(),
                                                        mobileController.text,
                                                        passwordController.text,
                                                        googleAccessTokenId
                                                            .toString(),
                                                        socialTypeGoogle
                                                            .toString(),
                                                        context)
                                                    .then((value) async {
                                                  if (value.status) {
                                                    getAlertDialog('Sign Up', value.message, () {Get.toNamed(
                                                          MyRouter.verifyEmailScreen,
                                                          arguments: [userNameController.text.toString()]);
                                                    });
                                                  } else {
                                                    getAlertDialog('Sign Up',
                                                        value.message, () {
                                                      Get.back();
                                                    });
                                                  }
                                                  return;
                                                });
                                              } else {
                                                register(
                                                        userNameController.text,
                                                    countryPostCode!=null ? "+$countryPostCode" : "+679",
                                                    countryIsoCode!=null ? "":"fj",
                                                        mobileController.text,
                                                        passwordController.text,
                                                        '',
                                                        "manual",
                                                        context)
                                                    .then((value) async {
                                                  if (value.status) {
                                                    verifySignupUserEmail(
                                                        userNameController,
                                                        context);
                                                    getAlertDialog('Sign Up',
                                                        value.message, () {
                                                      Get.offAndToNamed(
                                                          MyRouter
                                                              .verifyEmailScreen,
                                                          arguments: [
                                                            Get.arguments[0],
                                                            userNameController
                                                                .text
                                                          ]);
                                                    });
                                                  } else {
                                                    getAlertDialog('Sign Up',
                                                        value.message, () {
                                                      Get.back();
                                                    });
                                                  }
                                                  return;
                                                });
                                              }
                                            }
                                          }
                                        }),
                                  ),
                                  addHeight(8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.logInLogo,
                                  height: 100,
                                  width: 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Positioned(
              bottom: 12,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: Strings.login,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                          children: [
                            TextSpan(
                                text: Strings.loginNow,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.toNamed(
                                      MyRouter.logInScreen,
                                      arguments: ['mainScreen']),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w700,
                                )),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDropdownItem(Country country) => Container(
    child: Row(
      children: <Widget>[
        const SizedBox(
          width: 12.0,
        ),
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(child: Text("+${country.phoneCode}(${country.name})",overflow: TextOverflow.ellipsis,)),
        // Text("+${country.phoneCode}"),
      ],
    ),
  );
}
