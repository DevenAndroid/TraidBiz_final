import 'package:dinelah/res/size_config.dart';
import 'package:dinelah/res/theme/theme.dart';
import 'package:dinelah/routers/my_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return GetMaterialApp(
          darkTheme: ThemeData.light(),
          defaultTransition: Transition.rightToLeft,
          debugShowCheckedModeBanner: false,
          initialRoute: "/splash",
          getPages: MyRouter.route,
          theme: ThemeData(
              fontFamily: 'OpenSans',
              primaryColor: AppTheme.primaryColor,
              highlightColor: AppTheme.primaryColor,
              primarySwatch: AppTheme.primaryColorMaterial,
              cupertinoOverrideTheme: CupertinoThemeData(
                primaryColor: AppTheme.primaryColor,
              ),
              // for others(Android, Fuchsia)
              textSelectionTheme: TextSelectionThemeData(
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
    });
  }
}
