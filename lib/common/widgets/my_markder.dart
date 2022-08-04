import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyMarker extends StatelessWidget {
  // declare a global key and get it trough Constructor

  const MyMarker({required this.globalKeyMyWidget, required this.text});
  final GlobalKey globalKeyMyWidget;
  final String text;

  @override
  Widget build(BuildContext context) {
    // wrap your widget with RepaintBoundary and
    // pass your global key to RepaintBoundary
    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: 5,
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*  Image.asset(
                  'assets/img/location.png',
                  width: 800.w,
                  height: 80.w,
                ),
                Positioned(
                  width: 800,
                  child: Container(
                    width: 150.w,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ), */
              ],
            )),
          )
        ],
      ),
    );
  }
}
