import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

screemLoading({double? height = 400}) {
  return SkeletonLoader(
    builder: Container(
      height: height,
      width: 100.w,
      color: const Color.fromARGB(255, 237, 237, 237),
    ),
    items: 1,
    baseColor: Colors.white,
    period: const Duration(seconds: 2),
    highlightColor: Color.fromARGB(255, 214, 214, 214),
    direction: SkeletonDirection.ltr,
  );
}
