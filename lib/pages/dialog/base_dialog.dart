import 'package:flutter/material.dart';
import 'package:flutter_template/common/values/values.dart';
import 'package:flutter_template/common/widgets/widgets.dart';
import 'package:flutter_template/pages/dialog/countdown_timer.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets/circular_image.dart';

showBaseDialog({
  String? avatar,
  String? name,
  Widget? content,
  Widget? action,
  WillPopCallback? onWillPop,
  bool shrink: false,
  bool barrierDismissible: false,
  double? height,
  double? width,
  bool showClose: false,
}) {
  final dialogHeight = shrink ? null : height ?? 500.w;
  final dialogWidth = width ?? 680.w;

  Widget contentBody = Column(
    children: [
      Text(
        name ?? '',
        style: TextStyle(
            color: Colors.black, fontSize: 24.sp, fontWeight: FontWeight.w600),
      ),
      SizedBox(
        height: 40.w,
      ),
      content ?? SizedBox(),
      action ?? SizedBox(),
      SizedBox(
        height: shrink == true ? 60.w : 0,
      ),
    ],
  );

  Widget closeView() => InkWell(
        borderRadius: BorderRadius.all(Radius.circular(100.w)),
        onTap: Get.back,
        child: Image.asset(
          '${ImagePath.prefix}/close_pop.png',
          width: 50.w,
          height: 50.w,
          // color: Color(0xFFF7F7F7),
          fit: BoxFit.cover,
        ),
      );

  Widget dialogWidget = Center(
    child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: dialogWidth,
              height: dialogHeight,
              margin: EdgeInsets.only(top: 75.w, right: 60.w, left: 60.w),
              padding: EdgeInsets.only(top: 96.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  shrink ? contentBody : Expanded(child: contentBody),
                ],
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                    child: CircularImage(
                  source: avatar ?? '',
                  radius: 75.w,
                ))),
            if (showClose)
              Positioned(top: 36.w, right: 32.w, child: closeView()),
          ],
        )),
  );

  Get.dialog(
    onWillPop != null
        ? WillPopScope(
            onWillPop: onWillPop,
            child: dialogWidget,
          )
        : dialogWidget,
    barrierDismissible: barrierDismissible,
  );
}

showDefaultDialog({
  String? avatar,
  String? name,
  Widget? icon,
  String? title,
  String? desc,
  WillPopCallback? onWillPop,
  bool shrink: false,
  bool barrierDismissible: false,
  double? height,
  double? width,
  bool showClose: false,
}) {
  String url = avatar ??
      'https://img2.baidu.com/it/u=3086435497,3993261965&fm=253&fmt=auto&app=138&f=JPEG?w=200&h=200';
  showBaseDialog(
      avatar: url,
      name: name,
      content: buildDefaultContent(title ?? '', desc ?? '', icon: icon),
      action: buildOkButton(onClick: () {
        Get.back();
      }),
      onWillPop: onWillPop,
      shrink: shrink,
      barrierDismissible: barrierDismissible,
      height: height,
      width: width,
      showClose: showClose);
}

showDefaultThreeButtonDialog({
  String? avatar,
  String? name,
  Widget? icon,
  String? title,
  String? desc,
  WillPopCallback? onWillPop,
  bool shrink: false,
  bool barrierDismissible: false,
  double? height,
  double? width,
  Function? onClick,
  bool showClose: false,
}) {
  String url = avatar ?? '';
  showBaseDialog(
      avatar: url,
      name: name,
      content: buildDefaultContent(title ?? '', desc ?? '', icon: icon),
      action: buildThreeButton(onClick: (type) {
        if (onClick != null) {
          onClick(type);
        } else {
          Get.back();
        }
      }),
      onWillPop: onWillPop,
      shrink: shrink,
      barrierDismissible: barrierDismissible,
      height: height,
      width: width,
      showClose: showClose);
}

Widget get successIcon => Container(
      width: 56.w,
      height: 56.w,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Color(0xFF07C160)),
      child: Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 40.w,
      ),
    );

Widget get earlyIcon => Icon(
      Icons.access_time_filled,
      color: Color(0xFFF7B500),
      size: 66.w,
    );

Widget get failIcon => Container(
      width: 56.w,
      height: 56.w,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF65C53)),
      child: Icon(
        Icons.close_rounded,
        color: Colors.white,
        size: 40.w,
      ),
    );

Widget buildDefaultContent(String title, String desc,
    {Widget? icon, String? iconText, Widget? descContent}) {
  return Column(
    children: [
      icon ?? SizedBox(),
      if ((iconText ?? '').isNotEmpty)
        Container(
          margin: EdgeInsets.only(top: 12.w),
          child: Text(
            iconText ?? '',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
        ),
      SizedBox(
        height: icon != null ? 20.w : 0,
      ),
      if (title.isNotEmpty)
        Text(
          title ?? '',
          style: TextStyle(
              color: Colors.black,
              fontSize: 30.sp,
              fontWeight: FontWeight.bold),
        ),
      SizedBox(
        height: 20.w,
      ),
      if (desc.isNotEmpty && descContent == null)
        Text(
          desc ?? '',
          style: TextStyle(
            color: Color(0xFF313233),
            fontSize: 24.sp,
          ),
        ),
      descContent ?? SizedBox(),
      SizedBox(
        height: 40.w,
      )
    ],
  );
}

Widget buildOkButton(
    {double? width,
      Function? onClick,
    String? text,
    int seconds = 0}) {
  return InkWell(
    borderRadius: BorderRadius.circular(8.w),
    onTap: () {
      if (onClick != null) {
        onClick();
      }
    },
    child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 140.w),
      width: width??400.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text ?? 'OK',
            style: TextStyle(fontSize: 24.sp, color: Colors.white),
          ),
          if (seconds>0)
            CountDownTimer(
              seconds: seconds,
              onCompleted: () {
                Get.back();
              },
            ),
          // CountDownTimer(isDate:true,seconds: 1669863058,onCompleted: (){
          //   Get.back();
          // },),
        ],
      ),
    ),
  );
}

Widget buildThreeButton({Function? onClick}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      buildCircleButton('breakfast', 'Meal', onClick: () {
        if (onClick != null) {
          onClick('Meal');
        }
      }),
      SizedBox(
        width: 40.w,
      ),
      buildCircleButton('breakfast', 'Break', onClick: () {
        if (onClick != null) {
          onClick('Break');
        }
      }),
      SizedBox(
        width: 40.w,
      ),
      buildCircleButton('breakfast', 'Punch out', onClick: () {
        if (onClick != null) {
          onClick('Punch out');
        }
      }),
    ],
  );
}

Widget buildCircleButton(
  String iconName,
  String text, {
  Function? onClick,
}) {
  return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick();
        }
      },
      child: Container(
        width: 150.w,
        height: 150.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xFFD0D3D9), width: 1.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              '${ImagePath.prefix}/${iconName}.png',
              width: 48.w,
              height: 48.w,
            ),
            SizedBox(
              height: 12.w,
            ),
            Text(
              text ?? '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.sp,
              ),
            ),
          ],
        ),
      ));
}
