import 'dart:convert';

import 'package:client_information/client_information.dart';
import 'package:traidbiz/repositories/get_social_data_repository.dart';
import 'package:traidbiz/repositories/user_login_repository.dart';
import 'package:traidbiz/res/app_assets.dart';
import 'package:traidbiz/res/strings.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/routers/my_router.dart';
import 'package:traidbiz/ui/widget/common_button.dart';
import 'package:traidbiz/ui/widget/common_text_field.dart';
import 'package:traidbiz/ui/widget/common_widget.dart';
import 'package:traidbiz/utils/ApiConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/CustomNavigationBarController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ClientInformation _clientInfo;
  final loginFormKey = GlobalKey<FormState>();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();

  final controller = Get.put(CustomNavigationBarController());

  RxBool isDataLoading = false.obs;

  // Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _getClientInformation();
    // InternetConnectionChecker().onStatusChange.listen((status) {
    //   final connected = status == InternetConnectionStatus.connected;
    //   showSimpleNotification(
    //       Text(connected ? 'Connected to internet' : "NO INTERNET FOUND"),
    //       background: Colors.red);
    // });
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
  }

  RxBool isPasswordShow = true.obs;

  bool? isPassword = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
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
              child: InkWell(
                onTap: () {
                  // Get.toNamed(MyRouter.customBottomBar);
                },
                child: Image.asset(
                  AppAssets.logoWelcome,
                  width: screenSize.width * 0.7,
                  alignment: Alignment.topRight,
                ),
              ),
            ),
            Positioned(
                bottom: 36,
                child: Stack(
                  children: [
                    SizedBox(
                      width: screenSize.width,
                      child: Form(
                        key: loginFormKey,
                        child: Column(
                          children: [
                            Card(
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
                                    addHeight(screenSize.height * .04),
                                    Text(
                                      Strings.buttonLogin,
                                      style: const TextStyle(
                                          color: AppTheme.textColorDarkBLue,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 28),
                                    ),
                                    addHeight(8),
                                    labelText(Strings.loginToYourAccount),
                                    addHeight(24),
                                    CommonTextFieldWidget(
                                      hint: 'Email',
                                      controller: userNameController,
                                      icon: Icons.email_outlined,
                                      bgColor: AppTheme.etBgColor,
                                    ),
                                    addHeight(12),
                                    Obx(() => IntrinsicHeight(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller: passwordController,
                                                  obscureText:
                                                      isPasswordShow.value,
                                                  autofillHints: const [
                                                    AutofillHints.password
                                                  ],
                                                  validator: (value) {
                                                    if (isPassword!) {
                                                      if (value!
                                                          .trim()
                                                          .isEmpty) {
                                                        return 'Please enter password';
                                                      } else if (value.length <
                                                          4) {
                                                        return 'Password must be greater then 6';
                                                      }

                                                      // else if (value.length >
                                                      //     16) {
                                                      //   return 'Password must be less then 16';
                                                      // }

                                                    } else {
                                                      if (value!
                                                          .trim()
                                                          .isEmpty) {
                                                        return 'Please enter username or email';
                                                      } else if (value.length <
                                                          4) {
                                                        return 'Please enter valid username or email';
                                                      }
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                  maxLength: 32,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
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
                                                        borderSide:
                                                            const BorderSide(
                                                                color: AppTheme
                                                                    .primaryColorVariant),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
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
                                                          borderSide: const BorderSide(
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
                                    addHeight(4),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(MyRouter.forgotPassword);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            Strings.forgotPassword,
                                            style: const TextStyle(
                                                color:
                                                    AppTheme.textColorDarkBLue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    addHeight(24),
                                    CommonButton(
                                      buttonHeight: 6.5,
                                      buttonWidth: 95,
                                      mainGradient:
                                          AppTheme.secondaryGradientColor,
                                      text: Strings.buttonLogin,
                                      textColor: Colors.white,
                                      onTap: () async {
                                        var fcmToken = await FirebaseMessaging
                                            .instance
                                            .getToken();
                                        if (loginFormKey.currentState!
                                            .validate()) {
                                          // ignore: use_build_context_synchronously
                                          createLogin(
                                            userNameController.text,
                                            passwordController.text,
                                            _clientInfo.deviceId.toString(),
                                            fcmToken.toString(),
                                            context,
                                          ).then((value) async {
                                            if (value.status == true) {
                                              SharedPreferences pref = await SharedPreferences.getInstance();
                                              pref.setString('user', jsonEncode(value.data));

                                              controller.getUser();

                                              if (Get.arguments != null) {
                                                Get.offAndToNamed(MyRouter.customBottomBar);
                                                showToast(value.message);
                                              } else {
                                                Get.back();
                                              }
                                            } else {
                                              Get.defaultDialog(
                                                  title: 'Log In',
                                                  titleStyle: const TextStyle(
                                                      color: AppTheme
                                                          .primaryColor),
                                                  middleTextStyle:
                                                      const TextStyle(
                                                          color: Colors.white),
                                                  textConfirm: "Okay",
                                                  onConfirm: () {
                                                    Get.back();
                                                  },
                                                  confirmTextColor:
                                                      Colors.white,
                                                  buttonColor:
                                                      AppTheme.primaryColor,
                                                  radius: 10,
                                                  content: Text(value.message));
                                              // showToast(value.message);
                                            }
                                            return;
                                          });
                                        }
                                      },
                                    ),
                                    // addHeight(16),
                                    // Row(
                                    //   children: const [
                                    //     Expanded(child: Divider()),
                                    //     Text('  or  '),
                                    //     Expanded(child: Divider()),
                                    //   ],
                                    // ),
                                    addHeight(16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            signInWithGoogle1();
                                          },
                                          child: Container(
                                            height: 38,
                                            width: 38,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppTheme.primaryColor,
                                            ),
                                            child: const Center(
                                                child: FaIcon(
                                              FontAwesomeIcons.google,
                                              size: 18,
                                              color: Colors.white,
                                            )),
                                          ),
                                        ),
                                        addWidth(30),
                                        InkWell(
                                          onTap: () => signInFaceBook(),
                                          child: Container(
                                            height: 38,
                                            width: 38,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppTheme.textColorSkyBLue,
                                            ),
                                            child: const Center(
                                                child: FaIcon(
                                              FontAwesomeIcons.facebookF,
                                              size: 18,
                                              color: Colors.white,
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      // top: 6,
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
                )),
            Positioned(
              bottom: 20,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: Strings.signUp,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                          children: [
                            TextSpan(
                                text: Strings.signUpNow,
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => Get.toNamed(MyRouter.signUpScreen),
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

  //original
  Future<UserCredential> signInWithGoogle1() async {
    print("googleLogin method Called DINESH");
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleUser.id.toString(),
      accessToken: googleAuth.accessToken,
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('socialLoginId', googleUser.id.toString());

    getSocialLogin(
      context,
      googleUser.id.toString(),
      "google",
    ).then((value) async {
      if (value.status) {
        showToast(" login done userid is ${googleUser.id}");
        showToast(value.message);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('user', jsonEncode(value.data));
        Get.offAndToNamed(MyRouter.customBottomBar);
      } else {
        showToast(value.message);
        Get.offAndToNamed(MyRouter.signUpScreen, arguments: [
          googleUser.id.toString(),
          googleUser.email.toString(),
          googleUser.displayName.toString(),
          'google'
        ]);
      }
      return null;
    });
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInFaceBook() async {
    final LoginResult loginResult =
        await FacebookAuth.instance.login(permissions: ['email']);

    if (loginResult == LoginStatus.success) {
    } else {}

    final OAuthCredential oAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final userData = await FacebookAuth.instance.getUserData();

    print("acess token is  ::::::::::$userData");

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('fbLoginId', userData['id'].toString());

    print("acess token is kkkkkkkkk  ::::::::::${userData['id']}");
    getSocialLogin(context, userData['id'].toString(), "facebook")
        .then((value) async {
      if (value.status == true) {
        Fluttertoast.showToast(msg: value.message.toString());
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('user', jsonEncode(value.data));
        Get.offAndToNamed(MyRouter.customBottomBar);
      } else {
        Fluttertoast.showToast(
            msg: 'Email id not registered, please signUp first');
        Get.offAndToNamed(MyRouter.signUpScreen, arguments: [
          userData['id'].toString(),
          userData['email'].toString(),
          userData['name'].toString(),
          'facebook'
        ]);
      }
      return null;
    });

    return FirebaseAuth.instance.signInWithCredential(oAuthCredential);
  }
}
