import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/common/values/values.dart';
import 'package:flutter_template/common/widgets/widgets.dart';
import 'package:flutter_template/shared/version_update/version_update_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import '../../common/utils/storage.dart';
import 'version_update_model.dart';

Widget buildDialogContent({
  required String middleText,
  String? version,
}) {
  final Widget versionWidget = version == null
      ? Container()
      : Text(
          'V$version',
          style: TextStyle(
            fontSize: 28.sp,
          ),
        );

  return Stack(
    alignment: Alignment.topLeft,
    children: [
      Positioned(
        child: Image.asset(
          '${ImagePath.prefix}/app_update_dialog_head.png',
          fit: BoxFit.cover,
        ),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 72.w,
              horizontal: 48.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Version',
                  style: TextStyle(
                    fontSize: 44.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8.w,
                ),
                versionWidget
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32.w,
              vertical: 48.w,
            ),
            child: Container(
              constraints: BoxConstraints(maxHeight: 260.w),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    middleText,
                    style: TextStyle(
                      fontSize: 28.sp,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

class VersionUpdateController extends FullLifeCycleController
    with FullLifeCycleMixin {
  final api = Get.find<VersionUpdateApi>();
  var isDialogOpen = false;
  var currentPath;

  @override
  void onInit() {
    handleCheckAppVersion();
    super.onInit();
  }

  @override
  void onResumed() {
    handleCheckAppVersion();
  }

  Future<void> handleCheckAppVersion() async {
    if (isDialogOpen) return;

    final res = await api.checkAppVersion();
    if (res.statusCode != StatusCode.success) return;
    final versions = res.body?.data as List<VersionItem>;

    // final versions = [
    //   VersionItem(
    //     version: '2.3.2',
    //     osType: 0,
    //     note: 'update\nupdate',
    //     url: 'https://play.google.com',
    //   ),
    //   VersionItem(
    //     version: '2.3.4',
    //     osType: 1,
    //     note:
    //         'update\nupdate\nupdate\nupdate\nupdate\nupdate\nupdate\nupdate\nupdate\nupdate\nupdate',
    //     url: 'https://www.baidu.com',
    //   )
    // ];

    if (versions.isEmpty) return;

    final osType =
        Platform.isIOS ? UpdateVersionEnum.ios : UpdateVersionEnum.android;

    // always only two items
    final versionItem =
        versions.firstWhereOrNull((element) => element.osType == osType);

    if (versionItem == null) return;

    // final pattern = Platform.isIOS
    //     ? 'https://apps.apple.com/'
    //     : 'https://play.google.com/';

    // if ((versionItem.url ?? '').startsWith(pattern)) {
    //   throw 'No valid download url';
    // }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    final newVersionValue = Version.parse(versionItem.version);
    final currentVersionValue = Version.parse(currentVersion);

    if (currentVersionValue >= newVersionValue) {
      return;
    }

    // force update occur when major or minor version changes
    if (newVersionValue.major > currentVersionValue.major ||
        newVersionValue.minor > currentVersionValue.minor) {
      _buildDialog(
        // middleText:
        //     'ZERO& APP Version is too low. Please download and update the latest version',
        middleText: versionItem.note,
        redirectPath: versionItem.url,
        forceUpdate: true,
        version: versionItem.version,
      );

      // await Future.delayed(Duration(seconds: 2));
      // Get.toNamed(RouterPath.myOrderPage);
      return;
    }

    // normal update can skip when close dialog once
    if (Storage.skipUpdateVersion == versionItem.version) {
      return;
    }

    _buildDialog(
      middleText: versionItem.note,
      redirectPath: versionItem.url,
      forceUpdate: false,
      version: versionItem.version,
    );
  }

  void _buildDialog({middleText, redirectPath, forceUpdate, version}) {
    isDialogOpen = true;
    currentPath = Get.currentRoute;

    final onCancel = forceUpdate
        ? null
        : () {
            if (!forceUpdate) {
              Storage.skipUpdateVersion = version;
            }
            isDialogOpen = false;
            Get.back();
          };

    final onConfirm = () {
      if (!forceUpdate) {
        Storage.skipUpdateVersion = version;
      }
      _launchUrl(Uri.parse(redirectPath));
      isDialogOpen = false;
      Get.back();
    };

    confirmDialog(
      onWillPop: () => forceUpdate,
      shrink: true,
      bodyPadding: EdgeInsets.all(0),
      barrierDismissible: false,
      content: buildDialogContent(middleText: middleText, version: version),
      left: forceUpdate ? null : "Close",
      right: "Update",
      onLeft: () {
        if (onCancel == null) return;
        onCancel();
      },
      onRight: () {
        onConfirm();
      },
    );
  }

  void _launchUrl(_url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  // 保证在打开时，路由跳转引起的关闭
  static onRouteChange() {
    bool versionControllerExist = Get.isRegistered<VersionUpdateController>();
    if (versionControllerExist) {
      final versionController = Get.find<VersionUpdateController>();
      if (versionController.isDialogOpen) {
        if (versionController.currentPath != Get.currentRoute) {
          versionController.isDialogOpen = false;
        }
        versionController.onResumed();
      }
    }
  }
}
