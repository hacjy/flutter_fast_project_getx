import 'package:flutter/material.dart';
import 'package:flutter_template/common/utils/storage.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  refreshHome() {
    try {
      //超过一小时就刷新 点击tab或重新激活
      int refreshTime = Storage.refreshTime ?? 0;
      bool date = DateTime.fromMillisecondsSinceEpoch(refreshTime)
          .add(Duration(hours: 1))
          .isBefore(DateTime.now());
      if (date && refreshTime != 0) {
        // refreshController.callRefresh();
      }
    } catch (e) {}
  }
}
