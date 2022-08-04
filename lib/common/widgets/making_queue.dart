import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/common/widgets/widgets.dart';

List colros = [
  Color.fromRGBO(236, 236, 236, 1),
  const Color.fromRGBO(246, 92, 83, 1),
  const Color.fromARGB(171, 255, 186, 48),
  const Color.fromRGBO(155, 216, 85, 1),
];

var color = colros[0];

class MakingQueue extends StatelessWidget {
  MakingQueue({
    Key? key,
    this.currentOrderNum = 0,
    this.cupsInQueue = 0,
    this.currentValue = 0,
    this.businessStatus,
    this.timeText,
  }) : super(key: key);

  final int? currentOrderNum;
  final int? cupsInQueue;
  Text? timeText;
  double currentValue;
  final int? businessStatus;

  @override
  Widget build(BuildContext context) {
    if (currentValue >= 80) {
      color = colros[1];
    }
    if (currentValue >= 40 && currentValue < 80) {
      color = colros[2];
    }
    if (currentValue < 40) {
      color = colros[3];
    }
    if (businessStatus == 0) {
      currentValue = 0;
      timeText = Text('');
    }
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        FAProgressBarZero(
          borderRadius: BorderRadius.all(Radius.circular(50.w)),
          size: 40.w,
          currentValue: currentValue,
          progressColor: color,
          backgroundColor: Color.fromRGBO(236, 236, 236, 1),
        ),
        Align(
            // heightFactor: (2.3).w,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  Row(
                    children: [
                      businessStatus == 1 &&
                              currentOrderNum != 0 &&
                              cupsInQueue != 0
                          ? Row(
                              children: [
                                Text(
                                  '${currentOrderNum ?? ""}',
                                  style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  ' orders',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  ' / ',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  '${cupsInQueue ?? ""}',
                                  style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  ' cups in queue',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      businessStatus == 1 &&
                              currentOrderNum == 0 &&
                              cupsInQueue == 0
                          ? Text(
                              'Available Now',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          : SizedBox.shrink(),
                      businessStatus == 0
                          ? Text(
                              'Unavailable Now',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  Spacer(),
                  (businessStatus == 1 &&
                              currentOrderNum == 0 &&
                              cupsInQueue == 0) ||
                          businessStatus == 0
                      ? SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(right: 24.w),
                          child: timeText ?? Text(''),
                        ),
                ],
              ),
            )),
      ],
    );
  }
}
