import 'package:flutter/material.dart';
import 'package:flutter_template/common/values/values.dart';
import 'package:get/get_connect.dart';
import 'package:get/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:developer';

Widget showByCondition({required Widget widget, bool condition = false}) {
  if (!condition) return Container();
  return widget;
}

jsonToModel(String jsonString, Function fromJson) {
  var model;
  try {
    final obj = jsonDecode(jsonString);
    model = fromJson(obj);
  } catch (e) {
    log(e.toString());
  }
  return model;
}

Future<void> handleGetListBySize({
  int? pageNo,
  int pageSize = 10,
  reset = false,
  required RxInt currentPageNo,
  required RxList allList,
  required Function service,
  required Function getId,
}) async {
  if (reset) {
    currentPageNo.value = 1;
  } else if (pageNo != null) {
    currentPageNo.value = pageNo;
  }

  final Response response = await service();

  if (response.statusCode != StatusCode.success) return;
  if (reset) allList.clear();

  final List nextList = response.body?.data ?? [];
  if (nextList.isEmpty) return;

  // 考虑size变更以及最后一页的情况
  if (nextList.length == pageSize) {
    currentPageNo.value += 1;
  }
  try {
    if (allList.isNotEmpty) {
      nextList.forEach((element) {
        allList.removeWhere((ele) => getId(element) == getId(ele));
      });
    }
    allList.addAll(nextList);
  } catch (e) {
    log(e.toString());
  }
}

Response<T> handleResponse<T>(Response response, Function fromJson) {
  if (response.hasError) {
    return Response(statusCode: StatusCode.fail);
  }
  try {
    final data = fromJson(response.body);
    return Response(
      statusCode: data.code,
      statusText: data.msg,
      body: data,
    );
  } catch (e) {
    log('api response parse error ${e.toString()}');
    return Response(statusCode: StatusCode.fail);
  }
}

Future<bool> checkNotificationSetting() async {
  final isGranted = await Permission.notification.isGranted;
  return isGranted;
}
