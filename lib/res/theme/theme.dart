import 'dart:ui';

import 'package:traidbiz/res/theme/theme_color.dart';
import 'package:flutter/material.dart';

// class AppTheme {
//   static const Color primaryColor = Color(0xfff46924);
//   static const Color iconSelectionClr = Color(0xff004c83);
//   static const Color addToCartColorDK = Color(0xff035bb6);
// static const Color textColorDarkGreyDK = Color(0xFF293044);

//   static const Color newprimaryColor = Color(0xfff46924);
//   static const Color primaryColorVariant = Color(0x33394A6C);
//   static const Color textColorRed = Color(0xff573625);
//   static const Color textColorDarkBLue = Color(0xff035bb6);
//   static const Color textColorSkyBLue = Color(0xFF4a97cc);
//   static const Color colorEditFieldBg = Color(0xFFFEFEFE);
//   static const Color colorBackground = Color(0xffffffff);
//   static const Color textColorYellow = Color(0xfff46924);
//   static const Color etBgColor = Color(0xff004c83);
//   static const Color colorWhite = Color(0xffffffff);
//   static const Color primaryLightColor = Color(0xfffff6f0);
//   static const Color failRed = Color(0xfff46924);
//
//   static AppColor get colors {
//     return const AppColor.getColor();
//   }

class AppTheme {
  static const Color primaryColor = Color(0xfff46924);
  static const Color newprimaryColor = Color(0xfff46924);
  static const Color primaryColorVariant = Color(0x33394A6C);
  static const Color textColorRed = Color(0xFFE5001C);
  static const Color textColorDarkBLue = Color(0xFF1F2F40);
  static const Color textColorSkyBLue = Color(0xff1c50ea);
  static const Color colorEditFieldBg = Color(0xFFFEFEFE);
  static const Color colorBackground = Color(0xfffff6f7);
  static const Color textColorYellow = Color(0xFFf7ba03);
  static const Color etBgColor = Color(0xfff46924);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color primaryLightColor = Color(0x88242424);
  static const Color failRed = Color(0xFFFF0000);

  //custom
  static const Color iconSelectionClr = Color(0xff004c83);
  static const Color addToCartColorDK = Color(0xff035bb6);
  static const Color textColorDarkGreyDK = Color(0xFF293044);
  static AppColor get colors {
    return const AppColor.getColor();
  }

  static const primaryColorMaterial = const MaterialColor(0xFFAAD400, {
    50: const Color(0xfff46924),
    100: const Color(0xffdd6021),
    200: const Color(0xffdd6021),
    300: const Color(0xffdd6021),
    400: const Color(0xffdd6021),
    500: const Color(0xffdd6021),
    600: const Color(0xffdd6021),
    700: const Color(0xffdd6021),
    800: const Color(0xffdd6021),
    900: const Color(0xffdd6021)
  });
// use MaterialColor: myGreen.shade100,myGreen.shade500 ...
//   myGreen.shade50 // Color === 0xFFAAD401

  static const primaryGradientColor = LinearGradient(
    colors: [
      Color(0xff1c50ea),
      Color(0xff1c50ea),
    ],
    stops: [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const secondaryGradientColor = LinearGradient(
    colors: [
      Color(0xffdd6021),
      Color(0xffdd6021),
    ],
    stops: [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const primaryGradientColorGreen = LinearGradient(
    colors: [
      Color(0xFF4CAF50),
      Color(0xFF4CAF50),
    ],
    stops: [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const primaryGradientColorWhite = LinearGradient(
    colors: [
      Color(0xffffffff),
      Color(0xffffffff),
    ],
    stops: [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const buttonGradientColor = LinearGradient(
    colors: [
      Color(0xffffdc64),
      Color(0xffffdc64),
    ],
    stops: [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
