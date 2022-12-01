import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/global.dart';
import 'package:flutter_template/routers/router.dart';
import 'package:flutter_template/routers/router_path.dart';
import 'package:get/get.dart';

import 'common/utils/color.dart';
import 'common/utils/global_state.dart';
import 'init_binding.dart';
import 'shared/version_update/version_update_controller.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    await Global.init();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft, // 竖屏 Portrait 模式
        DeviceOrientation.landscapeRight,
      ],
    );

    runApp(const MyApp());
  }, (error, stack) async {
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      // designSize: const Size(750, 1623),
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, Widget? widget) {
        return GetMaterialApp(
          routingCallback: (routing) async {
            if (routing?.current != '/rewards') {
              //如果不是Rewards页面，就还原导航栏颜色
              SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ));
            }

            VersionUpdateController.onRouteChange();
          },
          theme: ThemeData(
            primarySwatch: createMaterialColor(const Color(0xffffffff)),
            primaryColor: const Color(0xffffffff),
            textTheme: TextTheme(
              bodyText1: TextStyle(fontSize: 16.sp),
              bodyText2: TextStyle(fontSize: 16.sp),
            ),
          ),
          initialRoute: RouterPath.camera,
          getPages: Routers.routes,
          builder: EasyLoading.init(),
          initialBinding: InitBinding(),
        );
      },
    );
  }
}
