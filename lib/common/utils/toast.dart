import 'package:flutter_easyloading/flutter_easyloading.dart';

showToast(String text, {int? time}) async {
  EasyLoading.instance.userInteractions = true;

  EasyLoading.showToast(text,
      duration: Duration(seconds: time ?? 3), //5秒
      toastPosition: EasyLoadingToastPosition.center);

  await Future.delayed(Duration(seconds: time ?? 3));
  EasyLoading.instance.userInteractions = false;
}
