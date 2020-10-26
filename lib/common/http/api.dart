import 'package:dio/dio.dart';
import 'package:flutter_app/common/http/http_manager.dart';

class Api {
  static String baseUrl = "https://www.wanandroid.com/";

  static HttpManager _http;

  //Banner
  static const String BANNER = "banner/json";

  //首页文章列表
  static const String ARTICLE_LIST = "article/list/";

  //登录
  static const String LOGIN = "user/login";

  //注册
  static const String REGISTER = "user/register";

  //收藏列表
  static const String COLLECT_ARTICLE_LIST = "lg/collect/list/";
  static const String COLLECT_WEBSITE_LIST = "lg/collect/usertools/json";

  //收藏站内
  static const String COLLECT_INTERNAL_ARTICLE = "lg/collect/";

  //取消收藏
  static const String UNCOLLECT_INTERNAL_ARTICLE = "lg/uncollect_originId/";

  static const String COLLECT_WEBSITE = "lg/collect/addtool/json";

  static const String UNCOLLECT_WEBSITE = "lg/collect/deletetool/json";

  static init() async {
    _http = HttpManager.getInstance();
    await _http.init();
  }

  /// https://www.wanandroid.com/banner/json
  static getBanner() async {
    return await _http.request(BANNER);
  }

  /// http://www.wanandroid.com/article/list/0/json
  static getArticleList(int curPage) async {
    return await _http.request("$ARTICLE_LIST/$curPage/json");
  }

  /// https://www.wanandroid.com/user/login
  static login(String name, String password) async {
    var formData = FormData.fromMap({"username": name, "password": password});
    return await _http.request(LOGIN, data: formData, method: "post");
  }

  /// https://www.wanandroid.com/user/register
  static register(String name, String pwd) async {
    ///必须使用Form表单提交
    var formData = FormData.fromMap(
        {"username": name, "password": pwd, "repassword": pwd});
    return await _http.request(REGISTER, data: formData, method: "post");
  }

  /// https://www.wanandroid.com/lg/collect/list/0/json
  static getArticleCollects(int curPage) async {
    return await _http.request("$COLLECT_ARTICLE_LIST/$curPage/json");
  }

  ///https://www.wanandroid.com/lg/collect/1165/json
  static collectArticle(int id) async {
    return await _http
        .request("$COLLECT_INTERNAL_ARTICLE$id/json", method: "post");
  }

  /// https://www.wanandroid.com/lg/uncollect_originId/2333/json
  static unCollectArticle(int id) async {
    return await _http
        .request("$UNCOLLECT_INTERNAL_ARTICLE$id/json", method: "post");
  }

  static void clearCookie() {
    _http.clearCookie();
  }
}
