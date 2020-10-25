import 'package:flutter_app/common/http/http_manager.dart';

class Api {
  static String baseUrl = "https://www.wanandroid.com/";
  static const String BANNER = "banner/json";

  static HttpManager _http;

  static init() async {
    _http = HttpManager.getInstance();
    await _http.init();
  }

  static getBanner() async {
    return await _http.request(BANNER);
  }

  void clearCookie() {
    _http.clearCookie();
  }
}
