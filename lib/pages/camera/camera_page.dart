import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/common/values/values.dart';
import 'package:flutter_template/pages/camera/widgets/custom_app_bar.dart';
import 'package:flutter_template/pages/camera/widgets/custom_camera.dart';
import 'package:flutter_template/pages/dialog/base_dialog.dart';
import 'package:get/get.dart';

import '../../common/widgets/circular_image.dart';
import 'camera_controller.dart';
import 'widgets/custom_camera_controller.dart';

class CameraPage extends StatelessWidget {
  final controller = Get.put(CameraController2());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              '${ImagePath.prefix}/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 48.w, left: 40.w),
            child: buildBody(),
          )
        ],
      ),
    );
  }

  Widget buildBody() {
    CustomCamera cameraView = CustomCamera(
      orientation:DeviceOrientation.landscapeLeft,
    );
    String url =
        'https://img2.baidu.com/it/u=3086435497,3993261965&fm=253&fmt=auto&app=138&f=JPEG?w=200&h=200';
    return Column(
      children: [
        CustomAppBar(title: 'ZERO& Stoneridge Mall',),
        Row(
          children: [
            CircularImage(
              source: url ?? '',
              radius: 45.w,
            ),
            SizedBox(
              width: 20.w,
            ),
            Text(
              'Sean Liang',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        cameraView,
        SizedBox(
          height: 60.w,
        ),
        Text(
          'Scanning...',
          style: TextStyle(
              color: Colors.black,
              fontSize: 36.sp,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20.w,
        ),
        Text(
          'Please look directly at the camera',
          style: TextStyle(
              color: Colors.black,
              fontSize: 28.sp,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 140.w,
        ),
        buildOkButton(
            width: 400.w,
            text: 'Take photo',
            onClick: () {
              cameraView.takePhoto((path){
                print('cameraView.takePhoto path=${path}');
                // Get.back();
                showDefaultDialog(
                    name: 'Sean Liang',
                    title: 'Punched in',
                    desc: 'Face every customer with a smile!',
                    icon: successIcon,
                    shrink: true);
              });
            }),
        Spacer(),
      ],
    );
  }
}
