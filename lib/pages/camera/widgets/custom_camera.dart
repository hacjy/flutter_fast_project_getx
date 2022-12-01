import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_editor/image_editor.dart';

import 'custom_camera_controller.dart' as CameraCtrl;

class CustomCamera extends StatefulWidget {
  final DeviceOrientation? orientation;
  _CustomCameraState? state;

  CustomCamera({this.orientation = DeviceOrientation.portraitUp});

  @override
  _CustomCameraState createState() {
    state = _CustomCameraState();
    return state!;
  }

  void takePhoto(Function onCall) {
    print('CustomCamera.takePhoto mounted=${state?.mounted}');
    if (state?.mounted == true) {
      state?.onTakePictureButtonPressed(onCall: onCall);
    }
  }
}

class _CustomCameraState extends State<CustomCamera>
    with WidgetsBindingObserver {
  CameraCtrl.CameraController? controller;
  List<CameraDescription> cameras = [];
  String filePath = '';
  final int cameraDirection = 1;
  double width = 340.w;
  double height = 340.w;

  void _camera({bool init = false, bool isDisposed = false}) async {
    if (isDisposed) {
      disposeCamera();
    }
    if (init) {
      cameras = await availableCameras();
    }
    if (cameras.isNotEmpty) {
      controller = CameraCtrl.CameraController(
          cameras[cameraDirection], ResolutionPreset.medium,
          deviceOrientation: widget.orientation,
          imageFormatGroup: ImageFormatGroup.jpeg);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  void disposeCamera() {
    if (controller != null) {
      controller?.dispose();
    }
  }

  @override
  void initState() {
    print('initState');
    // 添加监听器。生命周期变化，会回调到didChangeAppLifecycleState方法。
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _camera(init: true);
  }

  @override
  void dispose() {
    print('dispose');
    WidgetsBinding.instance.removeObserver(this);
    disposeCamera();
    super.dispose();
  }

  // 监听应用维度的生命周期变化。
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("app进入前台：resumed");
      pauseAndResumed(false);
    } else if (state == AppLifecycleState.inactive) {
      // 不常用：应用程序处于非活动状态，并且为接收用户输入时调用，比如：来电话了。
      print("app处于非活动状态：inactive");
      pauseAndResumed(true);
    }
  }

  void pauseAndResumed(bool isPause) {
    try {
      bool ret = controller?.isDisposed ?? false;
      print('isDisposed=${ret}');
      if (ret) {
        _camera(isDisposed: ret);
        return;
      }
      if (isPause) {
        controller?.pausePreview();
      } else {
        controller?.resumePreview();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return cameras.isEmpty || controller == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // if (filePath.isNotEmpty)
                //   Container(
                //       alignment: Alignment.center,
                //       decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           border: Border.all(
                //               color: Theme.of(context).primaryColor, width: 2)),
                //       child: ClipOval(
                //           child: Image.file(File(filePath),
                //               width: width / 2,
                //               height: height / 2,
                //               fit: BoxFit.cover))),
                // SizedBox(
                //   height: 20,
                // ),
                Container(
                  width: width,
                  height: height,
                  alignment: Alignment.center,
                  child: _cameraScan(),
                )
              ],
            ),
          );
  }

  Widget imageView() {
    return Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: ClipOval());
  }

  Widget _cameraScan() {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 6.w)),
      child: _cameraPreviewWidget(),
    );
  }

  bool isLandscape() {
    if (widget.orientation == DeviceOrientation.landscapeLeft ||
        widget.orientation == DeviceOrientation.landscapeRight) {
      return true;
    }
    return false;
  }

  Widget _cameraPreviewWidget() {
    return ClipOval(
        child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: isLandscape()
                ? buildLandscapePreview()
                : buildPortraitPreview()));
  }

  Widget buildPortraitPreview() {
    final size = MediaQuery.of(context).size;
    //竖屏
    double deviceRatio = size.height / size.width;
    if (isLandscape()) {
      //横屏
      deviceRatio = size.width / size.height;
    }
    // Transform.scale 比例缩放预览图，拍照出来的图片比较准确
    return Transform.scale(
        scale: controller!.value.aspectRatio,
        child: AspectRatio(
            aspectRatio: controller!.value.aspectRatio / deviceRatio,
            child: (controller?.isInitialized ?? false) == true
                ? controller!.buildPreview()
                : imageView()));
  }

  Widget buildLandscapePreview() {
    //横屏旋转 让预览图显示正确 -1:从左横屏变成竖直预览图
    return RotatedBox(quarterTurns: -1, child: buildPortraitPreview());
  }

  void onTakePictureButtonPressed({Function? onCall}) {
    print('CustomCamera.onTakePictureButtonPressed');
    takePicture().then((String filePath) {
      if (mounted) {
        if (filePath != null) {
          setState(() {
            this.filePath = filePath;
          });
        }
      }
      if (onCall != null) {
        onCall(this.filePath);
      }
    });
  }

  Future<String> takePicture() async {
    if (controller == null) {
      return "";
    }
    if (!controller!.value.isInitialized) {
      return "";
    }

    if (controller!.value.isTakingPicture) {
      return "";
    }

    //前置摄像头拍出来的图片是反的 通过image_editor插件和flutter_native_image插件处理
    try {
      XFile file = await controller!.takePicture();
      String path = file.path;
      File tempFile;

      Uint8List? bytes = await file.readAsBytes();
      var image = img.decodeImage(bytes);

      if (cameras[cameraDirection].lensDirection == CameraLensDirection.front) {
        /// 前置摄像头处理，后置摄像头一般不会出现问题
        ImageEditorOption option = ImageEditorOption();

        /// 翻转配置
        option.addOption(const FlipOption(horizontal: true));
        bytes = await ImageEditor.editImage(
            image: bytes!, imageEditorOption: option);

        await File(path).delete();
        tempFile = File(path);
        tempFile.writeAsBytesSync(bytes!);
        // 如果截图图片 注释掉该行代码，执行下面代码
        return tempFile.path;
      }

      /// 截取图片
      var offset = (image!.height - image.width) / 2;
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(path);
      properties.orientation = ImageOrientation.flipHorizontal;
      File cropedFile = await FlutterNativeImage.cropImage(
          file.path, 0, offset.round(), image.width, image.width);
      // img.bakeOrientation(image);
      return cropedFile.path;
    } on CameraException catch (e) {
      print(e.toString());
      return '';
    }
  }

  //前置摄像头拍出来的图片是反的
  //  Future<String> takePicture() async {
  //    if (!controller!.value.isInitialized) {
  //      print('Error: select a camera first.');
  //      return '';
  //    }
  //    if (controller!.value.isTakingPicture) {
  //      // A capture is already pending, do nothing.
  //      return '';
  //    }
  //    try {
  //      var ret = await controller!.takePicture();
  //      return ret.path;
  //    } on CameraException catch (e) {
  //      print("出现异常$e");
  //      return '';
  //    }
  //  }
}
