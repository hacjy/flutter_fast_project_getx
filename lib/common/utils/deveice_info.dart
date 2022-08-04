import 'dart:io';
import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future initPlatformState() async {
  var deviceData = <String, dynamic>{};
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } on PlatformException {
    deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
  }
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  return {...deviceData, "appVersion": packageInfo.version};
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'osType': 0,
    'osModel': build.model,
    'osVersion': build.version.release,
    'imei': build.fingerprint,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'osType': 1,
    'osModel': data.model,
    'osVersion': data.systemVersion,
    'imei': data.identifierForVendor,
  };
}
