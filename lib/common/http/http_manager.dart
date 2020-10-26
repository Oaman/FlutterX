import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_app/common/http/api.dart';
import 'package:path_provider/path_provider.dart';

class HttpManager {
  Dio _dio;
  PersistCookieJar _persistCookieJar;
  static HttpManager _instance;

  ///单例
  factory HttpManager.getInstance() {
    if (null == _instance) {
      _instance = HttpManager._internal();
    }
    return _instance;
  }

  ///_开头的是私有的
  HttpManager._internal();

  init() async {
    BaseOptions options = BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: 5000,
        sendTimeout: 5000,
        receiveTimeout: 5000);
    _dio = Dio(options);

    ///持久化存储
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    _persistCookieJar = PersistCookieJar(dir: appDocPath + "/.cookies/");
    _dio.interceptors.add(CookieManager(_persistCookieJar));
  }

  /// data为传递的参数，返回值默认为Future<Response.data>
  request(String path, {data, String method = "get"}) async {
    try {
      Options options = Options(method: method);
      Response response =
          await _dio.request(path, data: data, options: options);
      return response.data;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  void clearCookie() {}
}
