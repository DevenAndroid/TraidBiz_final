import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:traidbiz/res/size_config.dart';
import 'package:traidbiz/res/theme/theme.dart';
import 'package:traidbiz/routers/my_router.dart';
import 'package:traidbiz/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:traidbiz/utils/ApiConstant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return GetMaterialApp(
            supportedLocales: const [
              Locale('en'),
              Locale('el'),
              Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hans'), // Generic Simplified Chinese 'zh_Hans'
              Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hant'), // Generic traditional Chinese 'zh_Hant'
            ],
            darkTheme: ThemeData.light(),
            defaultTransition: Transition.rightToLeft,
            debugShowCheckedModeBanner: false,
            initialRoute: "/splash",
            getPages: MyRouter.route,
            builder: EasyLoading.init(),
            theme: ThemeData(
                errorColor: Colors.black,
                fontFamily: 'OpenSans',
                primaryColor: AppTheme.primaryColor,
                highlightColor: AppTheme.primaryColor,
                primarySwatch: AppTheme.primaryColorMaterial,
                cupertinoOverrideTheme: const CupertinoThemeData(
                  primaryColor: AppTheme.primaryColor,
                ),
                // for others(Android, Fuchsia)
                textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: AppTheme.primaryColor,
                    selectionColor: AppTheme.primaryColor),
                scrollbarTheme: const ScrollbarThemeData().copyWith(
                  thumbColor: MaterialStateProperty.all(AppTheme.primaryColor),
                ),
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(secondary: AppTheme.primaryColor)
                    .copyWith(secondary: AppTheme.primaryColor)),
          );
        });
      }),
    );
  }
}
