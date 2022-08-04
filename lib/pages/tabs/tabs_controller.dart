import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabsController extends GetxController {
  late PageController pageController;

  void jumpToPage(index) {
    pageController.jumpToPage(index);
  }

  void setPageController(PageController _pageController) {
    pageController = _pageController;
  }
}
