import 'dart:convert';
//import 'dart:developer';
// import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/common/utils/util.dart';
import 'package:flutter_template/common/values/values.dart';
import 'package:flutter_template/routers/router_path.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import 'base_model.dart';
import 'env/env.dart';
import 'loading.dart';
import 'storage.dart';
import 'toast.dart';

class BaseConnect extends GetConnect {
  _handleError(Response response, errMap, [int? requestNumber]) async {
    // final settingsC = Get.put(SettingsController());
    // String user = settingsC.userInfo.value.data?.name ?? '';
    // String id = settingsC.userInfo.value.data?.id ?? '';
    //TODO
    String user= '';
    String id= '';

    if (response.hasError) {
      Map<String, dynamic> _errMap = {
        "user": user,
        "id": id,
        "statusCode": response.statusCode,
        "statusText": response.statusText,
        "responsebody": response.bodyString,
        ...errMap,
      };
    }

    // 系统级别的报错，比如超时，无网络
    if (response.hasError && requestNumber == 2) {
      await hideLoading();
      showToast(
          'Network anomalies, please try again later #${response.statusCode == null ? '01' : '02'}');
      debugPrint('api error > url=${response.request!.url.path}');
    }
  }

  @override
  void onInit() async {
    super.onInit();

    //// test-scope-start
    if (kDebugMode) {
      final proxyConfig = dotenv.maybeGet('PROXY', fallback: '');
      if (proxyConfig != '') {
        findProxy = (url) => "PROXY $proxyConfig";
        allowAutoSignedCert = true;
      }
    } else {
      //系统代理
      setProxy();
      if (Storage.proxy != null) {
        findProxy = (uri) => "${Storage.proxy}";
      } else {
        findProxy = null;
      }
    }
    //// test-scope-end

    //httpClient.maxAuthRetries = 3; //重新请求三次
    httpClient.baseUrl = Server.baseUrl;
    // maxAuthRetries = 3;
    httpClient.addRequestModifier(
      (Request req) {
        return req..headers["Authorization"] = '${Storage.token}';
      },
    );
    httpClient.addResponseModifier(
      (req, res) {
        final body = BaseModel.fromJson(json.decode(res.bodyString ?? ''));
        if (body.code != StatusCode.success && body.code != StatusCode.loop) {
          //showToast('${body.code}\n${body.msg}');
          // hideLoading();
        }

        bool apiThatNoNeedLogout = req.url.path == '/v2/oauthLogin/healthCheck';

        if (StatusCode.notAuth == body.code &&
            Get.currentRoute != RouterPath.login &&
            !apiThatNoNeedLogout) {
          Storage.token = null;
          Get.offAllNamed(RouterPath.login);
        }
        return res;
      },
    );
  }

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      int requestNumber = 1}) {
    return Future(() async {
      final response = await super.get<T>(
        url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
      );
      //重复三次请求
      if (requestNumber < 3 && response.hasError) {
        get(url,
            headers: headers,
            contentType: contentType,
            query: query,
            decoder: decoder,
            requestNumber: requestNumber + 1);
      }
      var mapError = {
        "url": url,
        "headers": headers.toString(),
        "query": query.toString(),
      };
      _handleError(response, mapError, requestNumber);
      return response;
    });
  }

  @override
  Future<Response<T>> post<T>(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      Progress? uploadProgress,
      int requestNumber = 1}) {
    return Future(() async {
      final response = await super.post<T>(
        url,
        body,
        contentType: contentType,
        headers: headers,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
      var mapError = {
        "url": url,
        'body': body.toString(),
        "headers": headers.toString(),
        "query": query.toString(),
      };

      //重复三次请求
      if (requestNumber < 3 && response.hasError && url != 'order/placeOrder') {
        post(url, body,
            contentType: contentType,
            headers: headers,
            query: query,
            decoder: decoder,
            uploadProgress: uploadProgress,
            requestNumber: requestNumber + 1);
      }
      _handleError(response, mapError, requestNumber);
      return response;
    });
  }
}
