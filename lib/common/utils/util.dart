import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/common/utils/storage.dart';
import 'package:flutter_template/common/widgets/confirm_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:native_flutter_proxy/native_proxy_reader.dart';
import 'package:flutter/cupertino.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'formatter.dart';

setProxy() async {
  bool enabled = false;
  String? host;
  int? port;
  try {
    ProxySetting settings = await NativeProxyReader.proxySetting;
    enabled = settings.enabled;
    host = settings.host;
    port = settings.port;
  } catch (e) {}
  if (enabled && host != null) {
    Storage.proxy = 'PROXY $host:$port;';
  } else {
    Storage.proxy = null;
  }
}

DateTime getPSTTime(timezon) {
  tz.initializeTimeZones();

  final DateTime now = DateTime.now();
  if (timezon == '' || timezon == null) {
    log('time zone is empty');
    return now;
  }
  final pacificTimeZone = tz.getLocation(timezon);

  return tz.TZDateTime.from(now, pacificTimeZone);
}

Future getLocalTimeZone() async {
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  GetStorage().write('local_time_zone', currentTimeZone);
}

String formatDate(int timestamp,
    {String format = 'yyyy-MM-dd HH:mm:ss', String? timeZone}) {
  if (timestamp == 0) return '';
  final formatter = DateFormat(format);
  String? localZone = GetStorage().read('local_time_zone');
  String? timeZoneRet =
      (timeZone != null && timeZone!.isNotEmpty) ? timeZone : localZone;
  return formatter.format(timestampToDate(timestamp, timeZoneRet));
}

String formatDateString(String time,
    {String format = 'yyyy-MM-dd HH:mm:ss', String? timeZone}) {
  if (time.isEmpty) return '';
  var timestamp = DateTime.parse(time).millisecondsSinceEpoch;
  return formatDate(timestamp, format: format, timeZone: timeZone);
}

String formatDateShortString(String time, {String format = 'yyyy-MM-dd'}) {
  if (time.isEmpty) return '';
  return formatDateString(time, format: format);
}

String listToString(List<String> list) {
  String result = '';
  if (list.isEmpty) {
    return result;
  }
  list.forEach((element) =>
      {if (result.isEmpty) result = element else result = '$result、$element'});
  return result.toString();
}

String formatTimeOfDay(time) {
  final now = new DateTime.fromMillisecondsSinceEpoch(time, isUtc: true);
  final dt = DateTime(now.year, now.month, now.day, now.hour, now.minute);
  final format = DateFormat.jm(); //"6:00 AM"
  //DateFormat.jm().format(DateFormat('hh:mm:ss').parse(controller.storeDetail?.currentBusinessHours?.startTime ?? ''))
  var str =
      format.format(DateFormat('hh:mm').parse('${now.hour}:${now.minute}'));
  if (now.hour == 12) {
    str = str.replaceAll('AM', "PM");
  }
  return str;
}

void closeKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  /// 键盘是否是弹起状态
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

Future<LatLng> getPosition() async {
  final Location location = Location();
  if (!await location.serviceEnabled()) {
    if (!await location.requestService()) return LatLng(0, 0);
  }
  if (await location.hasPermission() == PermissionStatus.denied) {
    if (await location.requestPermission() != PermissionStatus.granted) {
      if (Platform.isIOS) {
        confirmDialog(
            title: 'Permission needed',
            height: 450.w,
            barrierDismissible: true,
            content: Text(
              'Position are currently disabled.Please grant permission to Fuji in your phone settings to receive Position',
              style: TextStyle(fontSize: 32.sp),
            ),
            left: "Cancel",
            right: "Confirm",
            onLeft: () {
              Get.back();
            },
            onRight: () async {
              AppSettings.openNotificationSettings();
              Get.back();
            });
        /*   Get.defaultDialog(
            title: 'Permission needed',
            barrierDismissible: false,
            onWillPop: () async => false,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 40.w,
              vertical: 20.w,
            ),
            titleStyle: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
            content: Text(
              'Position are currently disabled.Please grant permission to Fuji in your phone settings to receive Position',
              style: TextStyle(
                fontSize: 24.sp,
              ),
            ),
            textCancel: 'Cancel',
            cancelTextColor: Colors.black,
            textConfirm: 'Go to settings',
            confirmTextColor: Colors.black,
            onConfirm: () => {AppSettings.openNotificationSettings()}); */
      }
      return LatLng(0, 0);
    }
  }
  final LocationData data = await location.getLocation();
  return LatLng(data.latitude!, data.longitude!);
}
