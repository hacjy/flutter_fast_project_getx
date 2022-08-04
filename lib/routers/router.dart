import 'package:flutter_template/pages/home/home_page.dart';
import 'package:flutter_template/routers/router_path.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

class Routers {
  static final routes = [
    GetPage(
      name: RouterPath.home,
      page: () => new HomePage(),
    ),
  ];
}
