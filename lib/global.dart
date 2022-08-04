import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'common/utils/deveice_info.dart';
import 'common/utils/storage.dart';
import 'common/utils/util.dart';

///框架启动前的一些初始化工作放这里
class Global {

  static Future<void> init() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await GetStorage.init();
    tz.initializeTimeZones();

    // 获取当前时区
    await getLocalTimeZone();

    // 设备信息
    Storage.deviceInfo = await initPlatformState();
  }

}
