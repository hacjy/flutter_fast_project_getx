// ignore: file_names
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/common/utils/helper.dart';
import 'package:flutter_template/common/utils/storage.dart';
import 'package:flutter_template/common/widgets/confirm_dialog.dart';
import 'package:flutter_template/pages/tabs/tabs_controller.dart';
import 'package:get/get.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  late PageController _pageController;

  late final List<Widget> _pageList;
  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: _currentIndex,
      keepPage: true,
      viewportFraction: 1,
    );
    _pageList = [

    ];

    TabsController tabsController = Get.find<TabsController>();
    tabsController.setPageController(_pageController);
  }

  Widget _buildIconWithDot({required Widget widget}) {
    // MyMessageController controller = Get.find<MyMessageController>();
    return Obx(() {
      // if (controller.unreadCount.value == 0) {
      //   return widget;
      // }
      return Stack(
        alignment: Alignment(1.2, -1.2),
        children: [
          widget,
          Positioned(
            child: Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(246, 92, 83, 1),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pageList,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // physics: NeverScrollableScrollPhysics(),  //禁止pageView滑动，不配置默认可以滑动
      ),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: false,
        elevation: 10,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) async {
          final notifiable = await checkNotificationSetting();
          setState(() {
            _currentIndex = index;
            //跳转页面
            _pageController.jumpToPage(index);

            if (index == 0) {
              // refreshHome();
            }

            if (index == 3) {
              // 刷新未读
              // 接口稳定的话，可以去掉...
              // final messageController = Get.find<MyMessageController>();
              // messageController.debounceRefreshReadStatus();
              //
              // // 检测消息推送是否打开
              // if (!notifiable && Storage.notificationDialog == null) {
              //   Storage.notificationDialog = true;
              //   confirmDialog(
              //     barrierDismissible: true,
              //     title: 'Permission needs',
              //     left: 'Cancel',
              //     onLeft: () {
              //       Get.back();
              //     },
              //     right: 'Go to settings',
              //     onRight: () {
              //       Get.back();
              //       AppSettings.openNotificationSettings();
              //     },
              //     height: 450.w,
              //     content: Text(
              //       'Get notified of order status or new product notice by enabling notifications services',
              //       style: TextStyle(fontSize: 32.sp),
              //     ),
              //   );
              // }
            }
          });
        },
        unselectedItemColor: Color.fromRGBO(147, 149, 153, 1),
        type: BottomNavigationBarType.fixed,
        fixedColor: Color.fromARGB(255, 0, 0, 0),
        items: [
          BottomNavigationBarItem(
              tooltip: '',
              icon: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/img/home.png',
                  width: 48.w,
                  height: 48.w,
                ),
              ),
              activeIcon: Image.asset(
                'assets/img/home.png',
                width: 48.w,
                height: 48.w,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              tooltip: '',
              icon: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/img/my_order.png',
                  width: 48.w,
                  height: 48.w,
                ),
              ),
              activeIcon: Image.asset(
                'assets/img/my_order.png',
                width: 48.w,
                height: 48.w,
              ),
              label: "My Order"),
          BottomNavigationBarItem(
              tooltip: '',
              icon: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/img/rewards.png',
                  width: 48.w,
                  height: 48.w,
                ),
              ),
              activeIcon: Image.asset(
                'assets/img/rewards.png',
                width: 48.w,
                height: 48.w,
              ),
              label: "Rewards"),
          BottomNavigationBarItem(
              tooltip: '',
              icon: _buildIconWithDot(
                widget: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/img/settings.png',
                    width: 48.w,
                    height: 48.w,
                  ),
                ),
              ),
              activeIcon: _buildIconWithDot(
                widget: Image.asset(
                  'assets/img/settings.png',
                  width: 48.w,
                  height: 48.w,
                ),
              ),
              label: "Setting"),
        ],
      ),
    );
  }
}
