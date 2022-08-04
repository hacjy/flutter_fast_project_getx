import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../style.dart';

class Item extends StatelessWidget {
  Item(
      {Key? key,
      required this.title,
      this.icon,
      this.type = 'arrow',
      required this.tap,
      this.value = false,
      this.showArrow = true,
      this.secondTile = '',
      this.number = 0})
      : super(key: key);
  final String title;
  final Widget? icon;
  final String type;
  final Function tap;
  final String? secondTile;
  final bool? showArrow;
  final bool? value;
  final int number;

  final select = false.obs;

  Widget _buildActionImageWithNum({required Widget widget, required int num}) {
    if (num == 0) return widget;
    return Stack(
      alignment: Alignment(0.8, 0),
      children: [
        widget,
        Positioned(
          child: Container(
            constraints: BoxConstraints(minWidth: 40.w),
            padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 8.w),
            child: Text(
              num > 99 ? '99+' : '$num',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
            ),
            decoration: BoxDecoration(
              borderRadius:
                  num < 10 ? null : BorderRadius.all(Radius.circular(14.w)),
              shape: num < 10 ? BoxShape.circle : BoxShape.rectangle,
              color: Color.fromRGBO(246, 92, 83, 1),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (value != null) {
      select.value = value!;
    }
    Widget widget = Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 32.w),
      child: InkWell(
        enableFeedback: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.w, 23.w, 30.w, 23.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    icon ?? const SizedBox.shrink(),
                    Text(
                      title,
                      style: TextStyle(fontSize: Style.f32),
                    ),
                    const Spacer(),
                    Container(
                      constraints: BoxConstraints(maxWidth: 1.sw - 360.w),
                      child: Text(
                        '$secondTile'.replaceAll(' ', '\u00A0'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Style.f32,
                        ),
                      ),
                    ),
                    showArrow!
                        ? (type == 'arrow'
                            ? Icon(
                                Icons.arrow_forward_ios,
                                size: 22.w,
                                color: Color.fromRGBO(147, 149, 153, 1),
                              )
                            : Obx(() => FlutterSwitch(
                                  width: 100.w,
                                  height: 60.w,
                                  padding: 6.w,
                                  activeColor: Colors.black,
                                  value: select.value,
                                  onToggle: (value) {
                                    select.value = value;
                                    tap(select.value);
                                  },
                                )))
                        : const SizedBox.shrink(),
                  ]),
            ),
            const Divider(
              height: 1,
            )
          ],
        ),
        onTap: () {
          select.value = !select.value;
          tap(select.value);
        },
      ),
    );

    return _buildActionImageWithNum(widget: widget, num: this.number);
  }
}
