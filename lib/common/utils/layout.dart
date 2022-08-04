import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double getBottomHeight(BuildContext context) => Platform.isIOS
    ? ScreenUtil().bottomBarHeight
    : MediaQuery.of(context).viewPadding.bottom;
