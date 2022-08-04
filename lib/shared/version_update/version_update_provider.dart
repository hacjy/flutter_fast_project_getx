import 'package:flutter_template/common/values/server.dart';
import 'package:flutter_template/common/values/status_code.dart';
import 'package:get/get.dart';

import 'version_update_model.dart';

class VersionUpdateApi extends GetConnect {
  Future<Response<VersionUpdateModel>> checkAppVersion() async {
    final res = await post('${Server.baseUrl}version/queryVersions', {});
    if (res.hasError) {
      return Response(
        statusCode: StatusCode.fail,
      );
    }

    final data = VersionUpdateModel.fromJson(res.body);
    return Response(
      statusCode: data.code,
      statusText: data.msg,
      body: data,
    );
  }
}
