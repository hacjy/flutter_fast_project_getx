import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/common/values/image_path.dart';

class ImageIcons {
  static Widget get arrowRight => Image.asset(
        '${ImagePath.prefix}/arrow_right.png',
        width: 24.w,
        height: 24.w,
        fit: BoxFit.cover,
      );
}
