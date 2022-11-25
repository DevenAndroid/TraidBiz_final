import 'package:traidbiz/res/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonTextFieldWidgetForgotPassword extends StatelessWidget {
  IconData icon;
  Color bgColor;
  bool isPassword;
  RxBool isPasswordShow = false.obs;
  String hint;
  TextEditingController controller;
  FormFieldValidator validator;

  CommonTextFieldWidgetForgotPassword(
      {required this.validator,
      required this.icon,
      this.isPassword: false,
      required this.hint,
      required this.controller,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Obx(() => IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                    controller: controller,
                    obscureText: isPasswordShow.value,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (isPassword) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter password';
                        } else if (value.length <= 6) {
                          return 'Password must be greater then 6';
                        } else if (value.length > 16) {
                          return 'Password must be less then 16';
                        }
                      } else {
                        if (value!.trim().isEmpty) {
                          return "Please enter username or email";
                        } else if (value.length < 4) {
                          return 'Please enter valid username or email';
                        }
                      }
                      return null;
                    },
                    keyboardType:
                        isPassword ? TextInputType.text : TextInputType.text,
                    maxLength: isPassword ? 16 : 150,
                    textInputAction: isPassword
                        ? TextInputAction.done
                        : TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: hint,
                      errorStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      counterText: "",
                      filled: true,
                      hintStyle: TextStyle(color: Colors.white.withAlpha(200)),
                      fillColor: AppTheme.colorEditFieldBg.withAlpha(90),
                      focusColor: AppTheme.colorWhite,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 18),
                      // focusedBorder: InputBorder.none,
                      // enabledBorder: InputBorder.none,
                      // errorBorder: InputBorder.none,
                      // disabledBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
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
                      prefixIcon: Icon(
                        icon,
                        color: Colors.white,
                      ),
                    )),
              ),
            ],
          ),
        ));
  }
}
