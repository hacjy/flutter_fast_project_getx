import 'package:flutter_template/pages/tabs/tabs_controller.dart';
import 'package:flutter_template/routers/router_path.dart';
import 'package:get/get.dart';

void jumpToHome([int tabIndex = 0]) {
  final tabController = Get.find<TabsController>();
  tabController.jumpToPage(tabIndex);
  Get.until((route) => Get.currentRoute == RouterPath.home);
}
