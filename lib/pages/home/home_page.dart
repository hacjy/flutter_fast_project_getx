import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/common/utils/storage.dart';
import 'package:get/get.dart';

import '../dialog/base_dialog.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
     Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Container(
           alignment: Alignment.center,
           margin: EdgeInsets.symmetric(horizontal: 140.w),
           height: 140.w,
           decoration: BoxDecoration(
             shape: BoxShape.rectangle,
             color: Colors.blueAccent,

           ),
           child: InkWell(
             onTap: () {
               // showDefaultThreeButtonDialog(
               //   name: 'Sean Liang',
               //   title: 'What do you want to do？',
               //   desc: 'You have been punched in at 8:59 AM',
               //   shrink: true,
               // );
               showDefaultDialog(
                   name: 'Sean Liang',
                   title: 'Punched in',
                   desc: 'Face every customer with a smile!',
                   icon: successIcon,
                   shrink: true
               );
             },
             child: Text('open base dialog',style: TextStyle(color: Colors.white,fontSize: 32.sp),),
           ),
         ),
       ],
     ));
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
