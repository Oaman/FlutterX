import 'package:dio/dio.dart';
import 'package:flutter_app/common/http/http_manager.dart';

class Api {
  static String baseUrl = "https://www.wanandroid.com/";

  static HttpManager _http;

  //Banner
  static const String BANNER = "banner/json";

  //登录
  static const String LOGIN = "user/login";

  //注册
  static const String REGISTER = "user/register";

  static init() async {
    _http = HttpManager.getInstance();
    await _http.init();
  }

  static getBanner() async {
    return await _http.request(BANNER);
  }

  static login(String name, String password) async {
    var formData = FormData.fromMap({"username": name, "password": password});
    return await _http.request(LOGIN, data: formData, method: "post");
  }

  static register(String name, String pwd) async {
    ///必须使用Form表单提交
    var formData = FormData.fromMap(
        {"username": name, "password": pwd, "repassword": pwd});
    return await _http.request(REGISTER, data: formData, method: "post");
  }

  static void clearCookie() {
    _http.clearCookie();
  }
}
