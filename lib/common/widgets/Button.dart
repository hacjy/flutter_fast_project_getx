import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/common/style.dart';

class Button extends StatelessWidget {
  Button(
      {Key? key,
      required this.label,
      required this.onTap,
      this.fcolor,
      this.bColor,
      this.height,
      this.width,
      this.padding,
      this.style,
      this.icon,
      this.bgimage,
      this.decoration})
      : super(key: key);

  final String label;
  final void Function() onTap;
  final Color? bColor;
  final Color? fcolor;
  final Widget? icon;
  final DecorationImage? bgimage;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final TextStyle? style;
  final BoxDecoration? decoration;

  BoxDecoration? _getDecoration() {
    if (bgimage == null) return decoration;
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(70.w)),
      color: Colors.transparent,
      image: bgimage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 50.w),
        height: height ?? 87.w,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: style ??
                  TextStyle(
                      fontSize: Style.f32,
                      color: fcolor ?? Colors.white,
                      fontWeight: FontWeight.bold),
            ),
            icon ?? SizedBox.shrink(),
          ],
        ),
        decoration: _getDecoration(),
      ),
    );
  }
}
