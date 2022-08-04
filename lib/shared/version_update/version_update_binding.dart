import 'package:get/instance_manager.dart';

import 'version_update_controller.dart';

class VersionUpdateBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<VersionUpdateController>(VersionUpdateController());
  }
}
