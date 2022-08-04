import 'package:get/get.dart';

import 'storage.dart';

bool isLogin() {
  return Storage.token != null && Storage.token != '';
}

void refreshGlobalState() async {
  // refresh all state that can't dispose
}

void clearStorage() {
  Storage.token = null;
  Storage.storeId = null;
}

void invokeAfterLogin() async {
  refreshGlobalState();

  Storage.notificationDialog = null;
}
