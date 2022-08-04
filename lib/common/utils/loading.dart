import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_easyloading/src/widgets/overlay_entry.dart';

//https://docs.flutter.dev/development/tools/sdk/release-notes/release-notes-3.0.0

Timer? _timer;

Future<void> showLoading({
  bool userInteractions = false,
}) {
  EasyLoading.instance.userInteractions = userInteractions;

  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 9), (Timer timer) {
    hideLoading();
    _timer?.cancel();
    // showToast('System busy, please try again later or ask the staff for help');
  });
  return EasyLoading.show(
    // maskType: EasyLoadingMaskType.custom,
    // dismissOnTap: false,
    status: 'loading',
  );
}

Future<void> hideLoading() {
  _timer?.cancel();
  return EasyLoading.dismiss();
}
